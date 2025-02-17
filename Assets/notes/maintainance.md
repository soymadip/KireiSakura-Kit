---
title: .
---

<!DOCTYPE html>

<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Docs|KireiSakura-Kit</title>
    <meta name="color-scheme" content="dark" />
    <link
      rel="icon"
      href="https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/main/Assets/icon.png"
      type="image/png"
    />
    <style>
      :root {
        --base: #303446;
        --surface0: #292c3c;
        --text: #c6d0f5;
        --lavender: #babbf1;
        --maroon: #e29299;
        --teal: #4b7971;
      }

      body {
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 0;
        background-color: var(--surface0);
        font-family: Arial, sans-serif;
      }

      .popup-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
      }

      @keyframes popup {
        0% {
          transform: scale(0.5);
          opacity: 0;
        }
        100% {
          transform: scale(1);
          opacity: 1;
        }
      }

      .box {
        padding: 20px;
        border-radius: 8px;
        background-color: var(--base);
        border: 2px solid var(--maroon);
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        text-align: center;
        width: 400px;
        position: relative;
        animation: popup 2s ease-out;
      }

      .box img {
        max-width: 100px;
        height: auto;
      }

      h1 {
        font-size: 2.1rem;
        color: #f5b193;
        margin: 0;
      }

      h2 {
        font-size: 1.4rem;
        color: var(--text);
        margin: 20px 10px;
        margin-bottom: 5px;
      }

      p {
        font-size: 0.7rem;
        color: var(--teal);
        margin: 0;
      }

      a {
        color: inherit;
        text-decoration: none;
      }
    </style>

  </head>
  <body>
    <div class="popup-overlay">
      <div class="box">
        <img
          src="https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/main/Assets/icon.png"
          alt="KireiSakura-Kit Icon"
        />
        <h1>
          <a
            href="https://github.com/soymadip/KireiSakura-Kit"
            title="Visit KireiSakura-Kit on GitHub"
            >KireiSakura-Kit</a
          >
        </h1>
        <h2>Site on Maintanance</h2>
        <p>[ We will be back soon ]</p>
      </div>
    </div>
  </body>
</html>
