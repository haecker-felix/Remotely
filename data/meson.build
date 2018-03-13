# Resources
resources = gnome.compile_resources(
  'org.gnome.Remotely',
  'org.gnome.Remotely.gresource.xml',
  c_name: 'resources'
)

# Settings schema
install_data('org.gnome.Remotely.gschema.xml', install_dir : get_option('datadir') + '/glib-2.0/schemas/')

# Desktop file
i18n.merge_file(
  'org.gnome.Remotely.desktop',
  type: 'desktop',
  input: 'org.gnome.Remotely.desktop.in',
  output: 'org.gnome.Remotely.desktop',
  po_dir: po_dir,
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

# Appdata
i18n.merge_file(
  'org.gnome.Remotely.appdata.xml',
  input: 'org.gnome.Remotely.appdata.xml.in',
  output: 'org.gnome.Remotely.appdata.xml',
  po_dir: po_dir,
  install: true,
  install_dir: join_paths(get_option('datadir'), 'metainfo')
)

# Icons
install_subdir(
  'icons/hicolor',
  install_dir: join_paths(get_option('datadir'), 'icons')
)