#Fedora by default needs various fixes to be able to work properly.
#This module will fix those issues.

optimise_fedora() {
    prompt "Start optimizing Your Fedora?" confirm_otf
    if [ "$confirm_otf" == "y" ] || [ "$confirm_otf" == "Y" ] || [ -z "$confirm_otf" ]; then
            log.warn "checking if you are using fedora"
            local distro=$(get_distro_base)
            if [ "$distro" == "fedora" ]; then
                log.success "starting."

                log.warn "updating system"
                sudo dnf update

                log.warn "Enabling RPM Fusion Repository"
                sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

                log.warn "enabling fedora-cisco-openh264 Repo"
                sudo dnf config-manager --enable fedora-cisco-openh264

                log.warn "installing appstream-data"
                sudo dnf groupupdate core

                log.warn "Enabling FlatHub"
                flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

                log.warn "Installing Multimedia Plugins"
                sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
                sudo dnf install lame\* --exclude=lame-devel
                sudo dnf group upgrade --with-optional Multimedia

            fi
    fi
}

