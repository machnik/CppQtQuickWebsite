// Cross-origin isolation shim for static hosts (e.g. GitHub Pages) that don't allow
// setting custom COOP/COEP response headers. Based on the community "coi-serviceworker" pattern.
// Note: the registered worker rewrites headers for every fetch in its scope, so hosting
// unrelated content under the same path may also become subject to COEP/COOP.
if (typeof window !== 'undefined') {
    (async function() {
        const reloadGuardKey = 'coiServiceWorkerReloadAttempted';

        if (window.crossOriginIsolated !== false) {
            window.sessionStorage.removeItem(reloadGuardKey);
            return;
        }

        if (!('serviceWorker' in navigator)) {
            console.error('[COOP/COEP] Service workers are not supported; SharedArrayBuffer will be unavailable.');
            return;
        }

        let swRegistration = await navigator.serviceWorker.register(window.document.currentScript.src)
            .catch(error => console.error("[COOP/COEP: FAIL]", error));
        if (swRegistration) {
            swRegistration.addEventListener("updatefound", () => {
                window.location.reload();
            });
            if (swRegistration.active && !navigator.serviceWorker.controller) {
                // Reload once so the newly-registered worker can take control; avoid looping
                // forever if isolation still can't be achieved (e.g. inside an iframe without
                // allow="cross-origin-isolated", or if the browser blocks the worker).
                if (window.sessionStorage.getItem(reloadGuardKey)) {
                    console.error('[COOP/COEP] Reload did not enable cross-origin isolation; giving up.');
                    return;
                }
                window.sessionStorage.setItem(reloadGuardKey, '1');
                window.location.reload();
            }
        }
    })();
} else {
    self.addEventListener("install", () => self.skipWaiting());
    self.addEventListener("activate", event => event.waitUntil(self.clients.claim()));

    async function processFetch(req) {
        if (req.cache === "only-if-cached" && req.mode !== "same-origin") {
            return;
        }

        if (req.mode === "no-cors") {
            req = new Request(req, { credentials: "omit" });
        }

        let response;
        try {
            response = await fetch(req);
        } catch (error) {
            console.error(error);
            return Response.error();
        }

        if (response.status === 0) {
            return response;
        }

        const newHeaders = new Headers(response.headers);
        newHeaders.set("Cross-Origin-Embedder-Policy", "require-corp");
        newHeaders.set("Cross-Origin-Opener-Policy", "same-origin");

        return new Response(response.body, { status: response.status, statusText: response.statusText, headers: newHeaders });
    }

    self.addEventListener("fetch", function(event) {
        event.respondWith(processFetch(event.request));
    });
}
