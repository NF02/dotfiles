#!/bin/env bash

# Function to execute commands with elevated privileges
super_user_command() {
    local cmd="$*"
        sudo bash -c "$cmd"
    elif command -v doas &>/dev/null; then
        doas bash -c "$cmd"
    elif command -v su &>/dev/null; then
        su -c "$cmd"
    else
        echo "Error: No method available to gain elevated privileges (sudo, doas, or su not found)."
        exit 1
    fi
}

# Install build-essential and related packages
install_essential() {
    packages="apt install -y"
    packages+=" build-essential clang cmake pkg-config"
    super_user_command "apt update"
    super_user_command "$packages"
}

# Install GTK libraries for C and C++
install_gtk_c_cpp() {
    packages="apt install -y"
    packages+=" libgtk-3-dev libglib2.0-dev libgdk-pixbuf2.0-bin libpango1.0-dev libatk1.0-dev"
    super_user_command "apt update"
    super_user_command "$packages"
}

# Install Java SDK
install_java_sdk() {
    packages="apt install -y"
    packages+=" default-jdk openjdk-17-jdk"
    echo "Do you want to install GNOME and GTK support? (yes/no)"
    read -r gnome
    if [[ $gnome == "yes" || $gnome == "y" ]]; then
        packages+=" java-gnome"
    fi
    super_user_command "apt update"
    super_user_command "$packages"
}

# Install Emacs
install_emacs() {
    packages="apt install -y"
    echo "Do you want to install Wayland support? (yes/no)"
    read -r way
    if [[ $way == "yes" || $way == "y" ]]; then
        packages+=" emacs-pgtk sbcl"
    else
        packages+=" emacs-gtk sbcl"
    fi
    super_user_command "apt update"
    super_user_command "$packages"
}

# Install COBOL compiler
install_cobol() {
    packages="apt install -y"
    packages+=" gnucobol"
    super_user_command "apt update"
    super_user_command "$packages"
}

# Install 
# Display ASCII banner
cat << 'EOF'
╺┳┓┏━╸┏┓ ╻┏━┓┏┓╻   ╺┳┓┏━╸╻ ╻   ╺┳╸┏━┓┏━┓╻  ┏━┓   ╻┏┓╻┏━┓╺┳╸┏━┓╻  ╻  ┏━╸┏━┓
 ┃┃┣╸ ┣┻┓┃┣━┫┃┗┫    ┃┃┣╸ ┃┏┛    ┃ ┃ ┃┃ ┃┃  ┗━┓   ┃┃┗┫┗━┓ ┃ ┣━┫┃  ┃  ┣╸ ┣┳┛
╺┻┛┗━╸┗━┛╹╹ ╹╹ ╹   ╺┻┛┗━╸┗┛     ╹ ┗━┛┗━┛┗━╸┗━┛   ╹╹ ╹┗━┛ ╹ ╹ ╹┗━╸┗━╸┗━╸╹┗╸
------------------------- Select an option: ------------------------------
EOF

# Main menu loop
while true; do
    echo ""
    echo "1. Install build-essential"
    echo "2. Install GTK support for C and C++"
    echo "3. Install Java SDK"
    echo "4. Install Emacs"
    echo "5. Install COBOL compiler"
    echo "0. Quit"
    read -p "Choice: " choice

    case $choice in
        1) install_essential ;;
        2) install_gtk_c_cpp ;;
        3) install_java_sdk ;;
        4) install_emacs ;;
        5) install_cobol ;;
        0) echo "Exiting..."; break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
