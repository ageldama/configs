# 2011-11-25 22:42:16 ageldama@gmail.com


def io_popen_readall(cmd)
    h = IO.popen(cmd)
    s = h.read
    h.close
    return s
end


def installed_pkgs
    return io_popen_readall("dpkg -l | grep '^i' | awk '{print $2}'").split
end




def capture_1st(r, s)
    m = r.match(s)
    if m != nil then
        return m.captures[0]
    else
        return nil
    end
end

def pkg_size(pkg_name)
    stdout = io_popen_readall("apt-cache show #{pkg_name}")
    s = capture_1st(%r/^Installed-Size: (.*)$/, stdout)
    return s.to_i
end




installed_pkgs.map do |pkg_name|
    #puts "PKG=#{pkg_name}"
    pkg_size = pkg_size(pkg_name)
    puts "#{pkg_name}\t#{pkg_size}"
end




