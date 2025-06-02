import { readFileSync, writeFileSync } from 'fs';

interface CookieQuickManager {
  'Host raw': string;
  'Name raw': string;
  'Path raw': string;
  'Content raw': string;
  'Expires': string;
  'Expires raw': string;
  'Send for': string;
  'Send for raw': string;
  'HTTP only raw': string;
  'SameSite raw': string;
  'This domain only': string;
  'This domain only raw': string;
  'Store raw': string;
  'First Party Domain': string;
}

interface Cookie {
  name: string;
  [key: string]: string;
}

// Read the cookie quick manager export file
const cookieQuickManagerData: CookieQuickManager[] = JSON.parse(
  await Bun.file('cookie-quick-manager.json').text()
);

// Read the existing cookies.json to get the keys we need to extract
const existingCookies: Cookie = JSON.parse(
  await Bun.file('cookies.json').text()
);

// Get all keys except 'name' from the existing cookies
const targetKeys = Object.keys(existingCookies).filter(key => key !== 'name');

// Create a new cookie object with the filtered cookies
const newCookies: Cookie = {
  name: 'Cookie', // Always set name to 'Cookie'
};

// Find and add cookies from cookie-quick-manager.json that match our target keys
for (const cookie of cookieQuickManagerData) {
  const cookieName = cookie['Name raw'];
  if (targetKeys.includes(cookieName)) {
    newCookies[cookieName] = cookie['Content raw'];
  }
}

// Write the new cookies to cookies.json
await Bun.write('cookies.json', JSON.stringify(newCookies, null, 2));
