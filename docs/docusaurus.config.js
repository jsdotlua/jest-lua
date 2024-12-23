/** @type {import('@docusaurus/types').DocusaurusConfig} */

const VERSION = '3.10.0';

module.exports = {
  title: 'Jest Lua',
  tagline: 'Delightful Luau Testing',
  url: 'https://jsdotlua.github.io',
  baseUrl: '/jest-lua/',
  organizationName: 'jsdotlua',
  projectName: 'jest-lua',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.svg',
  staticDirectories: ['static'],
  trailingSlash: false,
  themeConfig: {
    navbar: {
      title: `Jest Lua v${VERSION}`,
      items: [
        {
          label: 'Docs',
          type: 'doc',
          docId: 'getting-started',
          position: 'right',
        },
        {
          label: 'API',
          type: 'doc',
          docId: 'api',
          position: 'right',
        },
        {
          href: 'https://github.com/jsdotlua/jest-lua',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
    },
    prism: {
      theme: require('prism-react-renderer').themes.github,
      darkTheme: require('prism-react-renderer').themes.dracula,
      additionalLanguages: ['lua', 'json', 'toml', 'diff'],
    }
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          routeBasePath: '/',
          // Please change this to your repo.
          // editUrl:
          //   'https://github.com/Roblox/jest-roblox-internal/edit/master/docs/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
