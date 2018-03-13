vala_sources = [
  'remotely-app.vala',
  'remotely-window.vala',
  'remotely-vnc-box.vala',
]

deps = [
  gtk_dep,
  gtk_vnc_dep,
]

c_args = [
  '-DVERSION="' + meson.project_version() + '"',
  '-DGETTEXT_PACKAGE="remotely"',
  '-DGNOMELOCALEDIR="' + get_option('prefix') + '/' + get_option('localedir') + '"'
]

vala_args = [
  '--target-glib=2.38'
]

executable(
  meson.project_name(),
  vala_sources + resources,
  dependencies: deps,
  vala_args: vala_args,
  c_args: c_args,
  install: true
)