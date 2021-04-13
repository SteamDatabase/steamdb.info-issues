(() => {
    const i = document.getElementById("freepackages"),
        o = document.getElementById("loading"),
        d = new Set;
    let r = window.SteamDB.Storage.Get("freepackages-hidden"),
        c = [];

    if (r) {
        r = r.split(",");
        for (const t of r) d.add(parseInt(t, 10));
        d.size > 0 && u()
    }

    $("#freepackages, #js-asf").on("click", (t) => {
        if (t.target.tagName === "A") return;
        const n = document.createRange();
        n.selectNodeContents(this);
        const e = window.getSelection();
        return e.removeAllRanges(), e.addRange(n), !1
    }),

    $("#js-hide-demos").one("click", () => {
        $("#js-hide-non-owned").parent().hide(), $(this).parent().text("Demos and legacy media have been hidden. Some demos may have remained because they are not marked correctly.");
        const t = document.querySelectorAll(".package");
        for (let n = 0; n < t.length; n++) {
            const e = t[n]; + e.dataset.parent < 0 && e.parentNode.removeChild(e)
        }
        document.querySelector(".package") || (o.textContent = "There are no free packages (besides demos) remaining for you.", o.style.display = "block", i.style.display = "none", document.getElementById("js-asf").style.display = "none"), l()
    }),

    $("#js-hide-non-owned").one("click", () => {
        $("#js-hide-demos").parent().hide(), $(this).parent().text("Only showing free content for your owned games.");
        const t = document.querySelectorAll(".package");
        for (let n = 0; n < t.length; n++) {
            const e = t[n]; + e.dataset.parent < 1 && e.parentNode.removeChild(e)
        }
        document.querySelector(".package") || (o.textContent = "There are no free packages (for games you own) remaining for you.", o.style.display = "block", i.style.display = "none", document.getElementById("js-asf").style.display = "none"), l()
    }),

    $(".js-remove").on("click", () => {
        const t = this.parentNode,
            n = +t.dataset.subid;
        return d.add(n), t.remove(), u(), l(), window.SteamDB.Storage.Set("freepackages-hidden", Array.from(d.values()).join(",")), document.querySelector(".package") || (o.textContent = "You have hidden all of the remaining packages.", o.style.display = "block", i.style.display = "none", document.getElementById("js-asf").style.display = "none"), !1
    }),

    $("#js-clear-hidden").on("click", () => {
        $("#js-hidden-subs").text("Reloading the page\u2026"), $(this).hide(), window.SteamDB.Storage.Remove("freepackages-hidden"), window.location.reload()
    }),

    $("#js-activate-now").one("click", () => {
        this.parentNode.hidden = true,
            o.textContent = `Activating ${c.length} packages\u2026`,
            o.style.display = "block", i.style.display = "none",
            document.getElementById("js-asf").style.display = "none";
        let t = 0;

        window.addEventListener("message", e => {
            if (e && e.data && e.data.type === "steamdb:extension-response") {
                if (!e.data.response || e.data.request.contentScriptQuery !== "StoreAddFreeLicense") return;
                const response = e.data.response.error || "OK";
                const a = document.createElement("div");
                let delay = 0;

                a.textContent = `Package ${e.data.request.subid}: ${response}`;
                o.appendChild(a);

                if (response.includes("rate limited")) {
                    a.textContent += "<br>Continuing in an hour\u2026"
                    delay = 60 * 60 * 1000;
                };

                setTimeout(addFreeLicense, delay);
            }
        });

        const addFreeLicense = () => {
            if (t < c.length) {
                window.postMessage({
                    type: "steamdb:extension-query",
                    contentScriptQuery: "StoreAddFreeLicense",
                    subid: c[t++]
                });
                return;
            }
            const e = document.createElement("div");
            e.textContent = "Done.", o.appendChild(e)
        };
        addFreeLicense();
    }),

    SteamDB.ExtensionUserdataLoaded.push(function(t, n) {
        let e = document.querySelectorAll(".package");
        o.textContent = "Processing...";
        const s = new Set;
        for (const a of e) {
            const p = +a.dataset.parent,
                g = +a.dataset.appid,
                m = +a.dataset.subid;
            if (p > 0 && !t.rgOwnedApps.includes(p) || p < 0 && t.rgOwnedApps.includes(p * -1) || t.rgOwnedPackages.includes(m) || t.rgOwnedApps.includes(g)) {
                s.add(g), a.parentNode.removeChild(a);
                continue
            }
            d.has(m) && a.parentNode.removeChild(a)
        }
        e = document.querySelectorAll(".package");
        for (const a of e) s.has(+a.dataset.appid) && a.parentNode.removeChild(a);
        s.clear(), document.querySelector(".package") ? (o.style.display = "none", i.style.display = "block", l()) : (o.textContent = "There are no free packages remaining for you.", document.getElementById("js-asf").style.display = "none")
    });

    function u() {
        $("#js-hidden-subs").text(Array.from(d.values()).join(", ")).parent().show()
    }

    function l() {
        const t = document.querySelectorAll(".package"),
            e = [];
        c = [];

        for (let i = 0; i < t.length; i++) {
            c.push(t[i].dataset.subid);
            e.push("a/" + t[i].dataset.appid);
        }

        document.getElementById("js-asf").textContent = "!addlicense " + e.join(",")
    }
})();