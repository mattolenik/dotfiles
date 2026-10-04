// @ts-check

/**
 * @typedef {import('/Applications/Finicky.app/Contents/Resources/finicky.d.ts').FinickyConfig} FinickyConfig
 */

/**
 * @type {FinickyConfig}
 */
export default {
  defaultBrowser: "Firefox",
  rewrite: [
    {
      // Codex only emits http(s) terminal links, so its markdown file references
      // use http://md.localhost/<absolute path> (see ~/.codex/AGENTS.md). Turn
      // them back into file:// URLs. pathname is already percent-encoded.
      match: (url) => url.host === "md.localhost",
      url: (url) => "file://" + url.pathname,
    },
  ],
  handlers: [],
};
