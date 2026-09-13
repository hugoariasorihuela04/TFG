const video = document.getElementById("video");
const canvas = document.getElementById("canvas");
const result = document.getElementById("result");
const button = document.getElementById("auth-btn");

// Detectar automáticamente la IP y puerto del backend
// El backend debe estar accesible desde el mismo host que el frontend
// pero en puerto 8000 en lugar de 8443
const API_BASE = `http://${window.location.hostname}:8000`;

console.log(`Usando API_BASE: ${API_BASE}`);

async function initCamera() {
    const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: "user" },
    });

    video.srcObject = stream;
}

function captureBlob() {
    return new Promise((resolve, reject) => {
        const context = canvas.getContext("2d");
        const track = video.srcObject.getVideoTracks()[0];
        const settings = track.getSettings();

        canvas.width = settings.width || video.videoWidth || 480;
        canvas.height = settings.height || video.videoHeight || 360;

        context.drawImage(video, 0, 0, canvas.width, canvas.height);

        canvas.toBlob(
            (blob) => {
                if (!blob) {
                    reject(new Error("No se pudo capturar la imagen"));
                    return;
                }
                resolve(blob);
            },
            "image/jpeg",
            0.9,
        );
    });
}

async function authenticateOnce() {
    const blob = await captureBlob();
    const formData = new FormData();
    formData.append("file", blob, "captura.jpg");
 
    const response = await fetch(`${API_BASE}/api/autenticar`, {
        method: "POST",
        body: formData,
    });
 
    if (!response.ok) {
        throw new Error(`Error en servidor: ${response.status}`);
    }
 
    const data = await response.json();
    return data;
}
 
button.addEventListener("click", async () => {
    button.disabled = true;
    result.textContent = "🔄 Autenticando...";
    result.parentElement.classList.remove("success", "error");
    result.parentElement.classList.add("loading");
 
    try {
        const intentos = [];
        let final = { autenticado: false };
 
        for (let i = 0; i < 10; i += 1) {
            const data = await authenticateOnce();
            intentos.push(data);
 
            if (data.autenticado === true) {
                final = data;
                break;
            }
 
            result.textContent = `🔄 Intento ${i + 1}/10...`;
            await new Promise((r) => setTimeout(r, 150));
        }
 
        const resultData = {
            autenticado: final.autenticado === true,
            intentos_realizados: intentos.length,
            confianza: final.detalles?.confianza.toFixed(2) || "N/A",
        };
 
        result.parentElement.classList.remove("loading");
        if (final.autenticado === true) {
            result.parentElement.classList.add("success");
            result.textContent = `✅ ¡Autenticación exitosa!\n\n${JSON.stringify(resultData, null, 2)}`;
        } else {
            result.parentElement.classList.add("error");
            result.textContent = `❌ Autenticación fallida\n\n${JSON.stringify(resultData, null, 2)}`;
        }
    } catch (error) {
        result.parentElement.classList.remove("loading");
        result.parentElement.classList.add("error");
        result.textContent = `❌ Error: ${error.message}`;
    } finally {
        button.disabled = false;
    }
});

initCamera().catch((error) => {
    result.textContent = `No se pudo acceder a la cámara: ${error.message}`;
});