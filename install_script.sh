#!/bin/bash

# تحديث النظام أولاً
echo "تحديث النظام..."
sudo apt update && sudo apt upgrade -y

# تثبيت البرامج المطلوبة
install_apps() {
  echo "تثبيت البرامج المطلوبة..."

  # تثبيت Google Chrome
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb -y

  # تثبيت VS Code
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update
  sudo apt install code -y

  # تثبيت Telegram
  sudo apt install telegram-desktop -y

  # تثبيت Diodon (مدير الحافظة)
  sudo apt install diodon -y
}

# إعدادات VS Code (Extensions)
setup_vscode() {
  echo "إعدادات VS Code..."

  # تثبيت الإضافات الخاصة بـ .NET و C#
  code --install-extension ms-dotnettools.csharp
  code --install-extension ms-dotnettools.dotnet-install-tool
  code --install-extension ms-vscode.csharp-dev-kit
  code --install-extension ms-vscode.live-preview
}

# إضافة صلاحيات sudo لتنفيذ shutdown بدون كلمة مرور
setup_sudoers() {
  echo "تعديل ملف sudoers لتفعيل shutdown بدون كلمة مرور..."
  sudo visudo -cf /etc/sudoers.d/shutdown
  echo "$USER ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee /etc/sudoers.d/shutdown
}

# إضافة اختصار Alt + P لإيقاف النظام
setup_shortcut() {
  echo "إعداد اختصار Alt + P لإيقاف النظام..."
  
  # إضافة اختصار لتشغيل shutdown في "Custom Shortcuts" باستخدام gnome
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
  
  # إعداد مسار اختصار
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 name 'Shutdown Now'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 command 'gnome-terminal -- sudo /usr/sbin/shutdown -h now'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 binding '<Alt>p'
}

# تنفيذ السكربت
install_apps
setup_vscode
setup_sudoers
setup_shortcut

echo "تم الانتهاء ✅"
