var opts = {
  container: 'epiceditor',
  textarea: "wiki_body",
  basePath: '/assets',
  clientSideStorage: false,
  localStorageName: 'epiceditor',
  useNativeFullscreen: false,
  parser: marked,
  theme: {
    base: '/themes/base/epiceditor.css',
    preview: '/themes/preview/github.css',
    editor: '/themes/editor/epic-light.css'
  },
  button: {
    preview: true,
    fullscreen: true,
    bar: "auto"
  },
  focusOnLoad: false,
  shortcut: {
    modifier: 18,
    fullscreen: 70,
    preview: 80
  },
  string: {
    togglePreview: 'Toggle Preview Mode',
    toggleEdit: 'Toggle Edit Mode',
    toggleFullscreen: 'Enter Fullscreen'
  },
  autogrow: false
}
