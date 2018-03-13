project(
  'remotely', ['vala', 'c'],
  version: '0.0.1',
  license: 'GPL3',
  meson_version: '>= 0.40.0'
)

gnome = import('gnome')
i18n = import('i18n')

cc = meson.get_compiler('c')
valac = meson.get_compiler('vala')

vapi_dir = join_paths (meson.source_root (), 'src', 'vapis')
po_dir = join_paths(meson.source_root(), 'po')

# Remotely dependencies
gtk_vnc_dep = dependency('gtk-vnc-2.0')
gtk_dep = dependency('gtk+-3.0', version : '>=3.20.10')

subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('postinstall.py')
