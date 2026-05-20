#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>


int pipe_write(const int fd, const char* s)
{
  return write(fd, s, strlen(s));
}

int main(int argc, char **argv)
{
  char *q = "really???";
  if (argc>1) {
    q = argv[argc-1];
  }

  int fd[2];
  pipe(fd); // fd[0] read, fd[1] write
  pid_t pid = fork();

  if (pid == 0) {
    // CHILD
    dup2(fd[0], STDIN_FILENO);
    close(fd[0]);
    close(fd[1]); // Close unused write end

    char *args[] = {
      "rofi",
      "-theme-str", "window {width: 200px; height: 150px;}",
      "-dmenu",
      "-p", q,
      "-sep", "\\n",
      "-eh", "2",
      "-markup-rows",
      "-format", "i",
      NULL,
    };
    execvp(args[0], args);
  } else {
    //    close(fd[0]); // 안 쓰는 읽기 닫기

    pipe_write(fd[1], "<span size='x-large' weight='heavy'>Yes</span>\n");
    pipe_write(fd[1], "<span size='x-large' weight='heavy'>No</span>\n");
    close(fd[1]);
    // TODO read + exitcode

    int wstatus = 0;
    while (1) {
            pid_t result = waitpid(pid, &wstatus, WNOHANG); // 블로킹 안 됨
            if (result == pid) {
                printf("rofi 창이 닫혔습니다.\n");
                break;
            } else if (result == 0) {
                // rofi가 아직 켜져 있음 -> 부모는 다른 작업(UI 갱신 등) 가능
                printf("rofi 작동 중... 다른 일 처리 가능\n");
                sleep(1);
            }
        }

  }
}
