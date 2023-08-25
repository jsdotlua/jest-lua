/** @type {import('@docusaurus/types').DocusaurusConfig} */

const VERSION = '3.4.1';

module.exports = {
  title: 'Jest Roblox',
  tagline: 'Lovely Luau Testing',
  url: 'https://roblox.github.io',
  baseUrl: '/',
  organizationName: 'roblox',
  projectName: 'jest-roblox',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.svg',
  themeConfig: {
    navbar: {
      title: `Jest Roblox v${VERSION}`,
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
          href: 'https://github.com/Roblox/jest-roblox',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
    },
    prism: {
      theme: require('prism-react-renderer/themes/github'),
      darkTheme: require('prism-react-renderer/themes/dracula'),
      additionalLanguages: ['lua'],
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
          //   'https://github.com/Roblox/jest-roblox/edit/master/docs/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
