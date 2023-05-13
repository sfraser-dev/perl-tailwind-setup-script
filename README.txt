https://www.youtube.com/watch?v=DZvO_omwQ_0

(0)
mkdir ./public
touch ./public/index.html

(1) - get package.json
npm init -y

(2) - get node_modules
npm install -D tailwindcss

(3) - get tailwind.config.js
npx tailwindcss init

(4) - edit tailwind.config.js content line:
from:
content: [],
to:
content: ["./public/**/*.{html,js}"],

(5) - new folder and files
mkdir ./public/css
touch ./public/css/style.css
touch ./public/css/tailwind.css

(5.5) boiler 
!<ent> boiler plate index.html

(5.6) link to tailwind.css in index.html
<link rel="stylesheet" href="./css/tailwind.css">


(6) - add 3 lines to style.css
@tailwind base;
@tailwind components;
@tailwind utilities;
echo "@tailwind base;" >> ./public/css/style.css
echo "@tailwind components;" >> ./public/css/style.css
echo "@tailwind utilities;" >> ./public/css/style.css

(7) run this command:
npx tailwindcss -i ./public/css/style.css -o ./public/css/tailwind.css --watch

(8) in package.json, change "scripts" key/value line:
from:
"test": "echo \"Error: no test specified\" && exit 1"
to:
"dev": "npx tailwindcss -i ./public/css/style.css -o ./public/css/tailwind.css --watch"

