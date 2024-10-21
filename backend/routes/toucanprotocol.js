const axios = require("axios");

const COINGECKO_API_URL = 'https://api.coingecko.com/api/v3/simple/price?ids=toucan-protocol-nature-carbon-tonne&vs_currencies=usd';

// Function to get TCO2 price from CoinGecko API
async function getTCO2Price() {
  try {
    const response = await axios.get(COINGECKO_API_URL);

    // Check if response contains the expected price field
    if (response.data && response.data['toucan-protocol-nature-carbon-tonne'] && response.data['toucan-protocol-nature-carbon-tonne'].usd) {
      return parseFloat(response.data['toucan-protocol-nature-carbon-tonne'].usd);
    } else {
      throw new Error('Unexpected response format');
    }
  } catch (error) {
    console.error('Error fetching TCO2 price:', error.message);
    throw error;
  }
}

// Function to calculate the amount in USDC based on the TCO2 price and credit points
async function calculateUSDCAmount(creditPoints) {
  try {
    const tco2Price = await getTCO2Price();
    const usdcAmount = creditPoints * tco2Price;
    return parseFloat(usdcAmount.toFixed(2));
  } catch (error) {
    console.error('Error calculating USDC amount:', error.message);
    throw error;
  }
}

// Export the functions
module.exports = {
  getTCO2Price,
  calculateUSDCAmount,
};