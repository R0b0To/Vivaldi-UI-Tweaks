(function keyboardMachine() {
  "use strict";

  // Prevent script from initializing multiple times on UI reloads
  if (window.keyboardMachineInitialized) return;
  window.keyboardMachineInitialized = true;

  /**
   * Define your keyboard shortcuts here.
   * Format: "Ctrl+Shift+KeyName" (Case-insensitive)
   */
  const SHORTCUTS = {
    "ctrl+shift+f4": togglePanel(".auto-hide-wrapper.has-tabbar"),
    "ctrl+shift+f1": togglePanel(".auto-hide-wrapper.has-mainbar"),
    "ctrl+shift+f2": togglePanel(".auto-hide-wrapper.right"),
  };

  /**
   * Creates a command handler for toggling visibility.
   * @param {string} selector CSS selector of the panel to toggle.
   */
  function togglePanel(selector) {
    return () => {
      const el = document.querySelector(selector);
      if (el) {
        el.classList.toggle("show");
      } else {
        console.warn(`[keyboardMachine] Element not found: ${selector}`);
      }
    };
  }

  /**
   * Handles custom keyboard shortcuts.
   */
  function keyCombo(sourceWindow, combination, autoRepeat) {
    // FIX: Explicitly reference window.vivaldiWindowId to prevent ReferenceErrors
    if (sourceWindow !== window.vivaldiWindowId || autoRepeat) return;
    
    // Normalize combination to lowercase to prevent case-mismatch errors
    const comboKey = combination.toLowerCase();
    const shortcutFn = SHORTCUTS[comboKey];
    
    if (shortcutFn) {
      shortcutFn();
    }
  }

  let retries = 0;
  const MAX_RETRIES = 20; // Stops trying after 10 seconds (20 * 500ms)

  /**
   * Wait for the browser UI to be ready before initializing.
   */
  function initMod() {
    const browser = document.querySelector("#browser");
    
    if (browser && window.vivaldi?.tabsPrivate?.onKeyboardShortcut) {
      window.vivaldi.tabsPrivate.onKeyboardShortcut.addListener(keyCombo);
      console.log("[keyboardMachine] Successfully initialized.");
    } else if (retries < MAX_RETRIES) {
      retries++;
      setTimeout(initMod, 500);
    } else {
      console.error("[keyboardMachine] Failed to initialize: Vivaldi API not found.");
    }
  }

  initMod();
})();