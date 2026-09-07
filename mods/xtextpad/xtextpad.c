#include <stdlib.h>
#include <gtk/gtk.h>
#include <gdk/gdkx.h>
#include <gdk/gdkkeysyms.h>
#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <X11/Xatom.h>


void send_shift_insert(Display *display, Window target_window)
{
  XKeyEvent event;
  KeyCode insert_code; //, shift_code;

  insert_code = XKeysymToKeycode(display, XK_Insert);
  //shift_code = XKeysymToKeycode(display, XK_Shift_L);

  event.type = KeyPress;
  event.display = display;
  event.window = target_window;
  event.root = DefaultRootWindow(display);
  event.subwindow = None;
  event.time = CurrentTime;
  event.x = 1;
  event.y = 1;
  event.x_root = 1;
  event.y_root = 1;
  event.same_screen = True;
  event.state = ShiftMask;
  event.keycode = insert_code;

#if 0
  // 3. Clear modifiers (--clearmodifiers equivalent)
  event.type = KeyPress;
  event.keycode = shift_code;
  event.state = 0; // No modifiers active initially
  XSendEvent(display, target_window, True, KeyPressMask, (XEvent *)&event);
#endif

  XSendEvent(display, target_window, True, KeyPressMask, (XEvent *)&event);

  event.type = KeyRelease;
  XSendEvent(display, target_window, True, KeyReleaseMask, (XEvent *)&event);

  XFlush(display);
}


// Returns the active Window ID on X11 display
Window get_active_window_gtk(GdkDisplay *gdk_display) {
  // Ensure we are running under X11, not Wayland
  if (!GDK_IS_X11_DISPLAY(gdk_display)) {
    g_printerr("Error: Active window retrieval is only supported under X11.\n");
    return None;
  }

  // Get raw Xlib Display and Root Window from GDK objects
  Display *xdisplay = GDK_DISPLAY_XDISPLAY(gdk_display);
  GdkScreen *screen = gdk_display_get_default_screen(gdk_display);
  Window xroot = GDK_WINDOW_XID(gdk_screen_get_root_window(screen));

  Atom net_active_window = XInternAtom(xdisplay, "_NET_ACTIVE_WINDOW", True);
  if (net_active_window == None) {
    return None;
  }

  Atom actual_type;
  int actual_format;
  unsigned long nitems, bytes_after;
  unsigned char *prop = NULL;

  int status = XGetWindowProperty(
                                  xdisplay, xroot, net_active_window,
                                  0, 1, False, XA_WINDOW,
                                  &actual_type, &actual_format, &nitems, &bytes_after, &prop
                                  );

  if (status != Success || prop == NULL || nitems == 0) {
    if (prop) XFree(prop);
    return None;
  }

  Window active_window = *(Window *)prop;
  XFree(prop);

  return active_window;
}


static void copy_buffer_to_clipboard(GtkTextBuffer *buffer) {
  GtkClipboard *clipboard = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD);
  GtkClipboard *primary   = gtk_clipboard_get(GDK_SELECTION_PRIMARY);

  GtkTextIter start, end;
  gtk_text_buffer_get_bounds(buffer, &start, &end);
  gchar *text = gtk_text_buffer_get_text(buffer, &start, &end, FALSE);

  gtk_clipboard_set_text(clipboard, text, -1);
  gtk_clipboard_set_text(primary, text, -1);

  gtk_clipboard_store(clipboard);

  /* g_print("--- COPIED ---\n%s\n----------------------\n", text); */

  g_free(text);

}


typedef struct {
  GtkTextBuffer *buffer;
  GtkWidget *button;
  GtkApplication *app;
  Window target_window;
} AppWidgets;


static gboolean delayed_exit_callback(gpointer user_data) {
    AppWidgets *app = (AppWidgets *)user_data;
    g_application_quit(G_APPLICATION(app->app));
    return G_SOURCE_CONTINUE; // G_SOURCE_REMOVE?
}

static void on_button_clicked(GtkButton *button, gpointer user_data) {
  AppWidgets *widgets = (AppWidgets *)user_data;

  GdkDisplay *display = gdk_display_get_default();

  copy_buffer_to_clipboard(widgets->buffer);
  Display *xdisplay = GDK_DISPLAY_XDISPLAY(display);
  send_shift_insert(xdisplay, widgets->target_window);

  //g_application_quit(G_APPLICATION(widgets->app));
  g_timeout_add(50, delayed_exit_callback, user_data);
}

static gboolean on_key_press(GtkWidget *widget, GdkEventKey *event, gpointer user_data) {
  AppWidgets *widgets = (AppWidgets *)user_data;

  guint modifiers = gtk_accelerator_get_default_mod_mask();
  if ((event->state & modifiers) == GDK_CONTROL_MASK &&
      (event->keyval == GDK_KEY_d || event->keyval == GDK_KEY_D)) {

    gtk_button_clicked(GTK_BUTTON(widgets->button));

    // stop propagation
    return TRUE;
  }

  return FALSE; // passthru
}

static void app_activate(GtkApplication *app, gpointer user_data) {
  g_object_set(gtk_settings_get_default(), 
               "gtk-application-prefer-dark-theme", TRUE, 
               NULL);

  AppWidgets *widgets = g_new0(AppWidgets, 1);

  widgets->target_window = (Window) user_data;

  // main window
  widgets->app = app;
  GtkWidget *window = gtk_application_window_new(app);
  gtk_window_set_title(GTK_WINDOW(window), "XTextPad");
  gtk_window_set_default_size(GTK_WINDOW(window), 400, 300);

  // vbox
  GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
  gtk_container_set_border_width(GTK_CONTAINER(vbox), 2);
  gtk_container_add(GTK_CONTAINER(window), vbox);

  // text-view + y-scrolled-window
  GtkWidget *text_view = gtk_text_view_new();
  gtk_text_view_set_wrap_mode(GTK_TEXT_VIEW(text_view), GTK_WRAP_WORD);
  widgets->buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(text_view));

  GtkWidget *scrolled_window = gtk_scrolled_window_new(NULL, NULL);
  gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
                                 GTK_POLICY_AUTOMATIC,
                                 GTK_POLICY_AUTOMATIC);
  gtk_container_add(GTK_CONTAINER(scrolled_window), text_view);

  g_signal_connect(window, "key-press-event", G_CALLBACK(on_key_press), widgets);

  // button
  GtkWidget *button = gtk_button_new_with_label("Send (^D)");
  widgets->button = button;
  g_signal_connect(button, "clicked", G_CALLBACK(on_button_clicked), widgets);

  // gtk_box_pack_start(box, child, expand, fill, padding)
  gtk_box_pack_start(GTK_BOX(vbox), scrolled_window, TRUE, TRUE, 0);
  gtk_box_pack_start(GTK_BOX(vbox), button, FALSE, FALSE, 0);

  //
  g_signal_connect_swapped(window, "destroy", G_CALLBACK(g_free), widgets);

  gtk_widget_show_all(window);
}

int main(int argc, char **argv) {
  // gdk
  gdk_init(&argc, &argv);
  GdkDisplay *display = gdk_display_get_default();

  if (!display) {
    fprintf(stderr, "Failed to open default GDK display.\n");
    exit(EXIT_FAILURE);
  }

  if (!GDK_IS_X11_DISPLAY(display)) {
    fprintf(stderr, "Not a GDK-X11 display.\n");
    exit(EXIT_FAILURE);
  }

  Window wind = get_active_window_gtk(display);
  fprintf(stderr, "active-window: %p\n", (void *)wind);

  // gtk
  GtkApplication *app = gtk_application_new("io.github.ageldama.XTextPad", G_APPLICATION_DEFAULT_FLAGS);
  g_signal_connect(app, "activate", G_CALLBACK(app_activate), (gpointer) wind);

  int status = g_application_run(G_APPLICATION(app), argc, argv);
  g_object_unref(app);

  return status;
}
