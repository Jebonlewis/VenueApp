const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

// Define your proxy middleware
const apiProxy = createProxyMiddleware('/api', {
  target: 'https://localhost:443', // Change to your backend server's URL and port
  changeOrigin: true,
  secure: false, // Set to false if your backend uses HTTPS
});

// Apply the proxy middleware to the specified endpoint
app.use('/api', apiProxy);

// Start the server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Proxy server is running on port ${PORT}`);
});
