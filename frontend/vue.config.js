module.exports = {
  pwa: {
    name: 'Clash Royale: Clan Monitor',
    themeColor: '#4DBA87',
    msTileColor: '#000000',
    appleMobileWebAppCapable: 'yes',
    appleMobileWebAppStatusBarStyle: 'black',

    workboxPluginMode: 'GenerateSW',
    workboxOptions: {
      skipWaiting: true
    }
  }
}
