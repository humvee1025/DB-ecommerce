// ================= VALIDATIONS =================
function validateText(text) {
    return /^[A-Z ]+$/.test(text);
}

function validateNumber(n) {
    return !isNaN(n);
}

// ================= CESAR =================
function cesar(text, shift) {
    let result = "";
    shift = shift % 26;

    for (let i = 0; i < text.length; i++) {
        if (text[i] === " ") {
            result += " ";
            continue;
        }

        let code = text.charCodeAt(i);
        let newChar = ((code - 65 + shift + 26) % 26) + 65;
        result += String.fromCharCode(newChar);
    }

    return result;
}

// ================= AFFINE =================
function gcd(a, b) {
    while (b !== 0) {
        let t = b;
        b = a % b;
        a = t;
    }
    return a;
}

function modInverse(a, m) {
    a = a % m;
    for (let x = 1; x < m; x++) {
        if ((a * x) % m === 1) return x;
    }
    return null;
}

function affineEncrypt(text, a, b) {
    let result = "";

    for (let i = 0; i < text.length; i++) {
        if (text[i] === " ") {
            result += " ";
            continue;
        }

        let x = text.charCodeAt(i) - 65;
        let y = (a * x + b) % 26;
        result += String.fromCharCode(y + 65);
    }

    return result;
}

function affineDecrypt(text, a, b) {
    let result = "";
    let a_inv = modInverse(a, 26);

    if (a_inv === null) {
        alert("❌ 'a' invalide");
        return "";
    }

    for (let i = 0; i < text.length; i++) {
        if (text[i] === " ") {
            result += " ";
            continue;
        }

        let y = text.charCodeAt(i) - 65;
        let x = (a_inv * (y - b + 26)) % 26;
        result += String.fromCharCode(x + 65);
    }

    return result;
}

// ================= VIGENERE =================
function vigenereEncrypt(text, key) {
    let result = "";
    key = key.toUpperCase();
    let j = 0;

    for (let i = 0; i < text.length; i++) {
        if (text[i] === " ") {
            result += " ";
            continue;
        }

        let x = text.charCodeAt(i) - 65;
        let k = key.charCodeAt(j % key.length) - 65;

        let y = (x + k) % 26;
        result += String.fromCharCode(y + 65);
        j++;
    }

    return result;
}

function vigenereDecrypt(text, key) {
    let result = "";
    key = key.toUpperCase();
    let j = 0;

    for (let i = 0; i < text.length; i++) {
        if (text[i] === " ") {
            result += " ";
            continue;
        }

        let y = text.charCodeAt(i) - 65;
        let k = key.charCodeAt(j % key.length) - 65;

        let x = (y - k + 26) % 26;
        result += String.fromCharCode(x + 65);
        j++;
    }

    return result;
}

// ================= AUTOKEY =================
function autokeyEncrypt(text, key) {
    let result = "";
    key = key.toUpperCase() + text.toUpperCase();
    let j = 0;

    for (let i = 0; i < text.length; i++) {
        if (text[i] === " ") {
            result += " ";
            continue;
        }

        let p = text.charCodeAt(i) - 65;
        let k = key.charCodeAt(j) - 65;

        let c = (p + k) % 26;
        result += String.fromCharCode(c + 65);
        j++;
    }

    return result;
}

function autokeyDecrypt(text, key) {
    let result = "";
    key = key.toUpperCase();
    let j = 0;

    for (let i = 0; i < text.length; i++) {
        if (text[i] === " ") {
            result += " ";
            continue;
        }

        let c = text.charCodeAt(i) - 65;
        let k = key.charCodeAt(j) - 65;

        let p = (c - k + 26) % 26;
        result += String.fromCharCode(p + 65);

        key += String.fromCharCode(p + 65);
        j++;
    }

    return result;
}

// ================= PLAYFAIR =================
function generateMatrix(key) {
    key = key.toUpperCase().replace(/J/g, "I");
    let alphabet = "ABCDEFGHIKLMNOPQRSTUVWXYZ";
    let matrix = [];
    let used = new Set();

    let fullKey = key + alphabet;

    for (let char of fullKey) {
        if (!used.has(char)) {
            matrix.push(char);
            used.add(char);
        }
    }

    return matrix;
}

function findPos(matrix, char) {
    let index = matrix.indexOf(char);
    return [Math.floor(index / 5), index % 5];
}

function playfairEncrypt(text, key) {
    let matrix = generateMatrix(key);
    text = text.toUpperCase().replace(/J/g, "I").replace(/ /g, "");

    let result = "";

    for (let i = 0; i < text.length; i += 2) {
        let a = text[i];
        let b = text[i + 1] || "X";

        let [r1, c1] = findPos(matrix, a);
        let [r2, c2] = findPos(matrix, b);

        if (r1 === r2) {
            result += matrix[r1 * 5 + (c1 + 1) % 5];
            result += matrix[r2 * 5 + (c2 + 1) % 5];
        } else if (c1 === c2) {
            result += matrix[((r1 + 1) % 5) * 5 + c1];
            result += matrix[((r2 + 1) % 5) * 5 + c2];
        } else {
            result += matrix[r1 * 5 + c2];
            result += matrix[r2 * 5 + c1];
        }
    }

    return result;
}

// ================= MAIN =================
function encrypt() {
    let algo = document.getElementById("algo").value;
    let text = document.getElementById("text").value.toUpperCase().trim();
    let key1 = document.getElementById("key1").value;
    let key2 = document.getElementById("key2").value;

    if (!validateText(text)) {
        alert("⚠️ Texte invalide");
        return;
    }

    let result = "";

    if (algo === "cesar") result = cesar(text, parseInt(key1));
    if (algo === "affine") result = affineEncrypt(text, parseInt(key1), parseInt(key2));
    if (algo === "vigenere") result = vigenereEncrypt(text, key1);
    if (algo === "autokey") result = autokeyEncrypt(text, key1);
    if (algo === "playfair") result = playfairEncrypt(text, key1);

    document.getElementById("result").innerText = result;
}

function decrypt() {
    let algo = document.getElementById("algo").value;
    let text = document.getElementById("text").value.toUpperCase().trim();
    let key1 = document.getElementById("key1").value;
    let key2 = document.getElementById("key2").value;

    let result = "";

    if (algo === "cesar") result = cesar(text, -parseInt(key1));
    if (algo === "affine") result = affineDecrypt(text, parseInt(key1), parseInt(key2));
    if (algo === "vigenere") result = vigenereDecrypt(text, key1);
    if (algo === "autokey") result = autokeyDecrypt(text, key1);
    if (algo === "playfair") result = "❌ Déchiffrement Playfair non implémenté";

    document.getElementById("result").innerText = result;
}