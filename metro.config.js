const { getDefaultConfig } = require('@react-native/metro-config');

module.exports = {
  ...getDefaultConfig(__dirname),
  resolver: {
    blockList: [
      /_context\/.*/,
      /_meta\/.*/,
      /shared\/.*/,
      /\.claude\/.*/,
      /\.github\/.*/,
    ],
  },
};
