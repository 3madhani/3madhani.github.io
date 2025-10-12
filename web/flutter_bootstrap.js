{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async (engineInitializer) => {
    console.log('Entrypoint loaded, initializing engine…');
    const appRunner = await engineInitializer.initializeEngine();
    console.log('Engine initialized, running app…');
    await appRunner.runApp();

    // Auto-reload on new service worker install
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.getRegistration().then(reg => {
        if (reg) {
          reg.onupdatefound = () => {
            const newWorker = reg.installing;
            newWorker.onstatechange = () => {
              if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
                console.log('⚡ New version available, reloading…');
                window.location.reload();
              }
            };
          };
        }
      });
    }
  }
});
