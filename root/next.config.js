/** @type {import('next').NextConfig} */
const { CLIENT_URL } = process.env;
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  assetPrefix: "client/",
  async rewrites() {
    return [
      {
        source: "/:path*",
        destination: `/:path*`,
      },
      {
        source: "/client",
        destination: `${CLIENT_URL}/client`,
      },
      {
        source: "/client/:path*",
        destination: `${CLIENT_URL}/client/:path*`,
      },
    ];
  },
}

module.exports = nextConfig
