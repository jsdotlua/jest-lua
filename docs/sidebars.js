module.exports = {
  docs: [
    {
      type: 'category',
      label: 'Introduction',
      items: [
        'getting-started',
        'using-matchers',
        'asynchronous',
        'setup-teardown',
        'mock-functions',
      ],
    },
    {
      type: 'category',
      label: 'Guides',
      items: [
        'snapshot-testing',
        'timer-mocks',
        'global-mocks',
        'testez-migration',
        'upgrading-to-jest3',
      ]
    },
    'deviations',
  ],
  api: [
    'api',
    'expect',
    'mock-function-api',
    'jest-object',
    'jest-benchmark',
    'configuration',
    'cli',
  ]
};
