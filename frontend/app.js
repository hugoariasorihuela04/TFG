const videoElemento = document.getElementById("video");
const lienzo = document.getElementById("canvas");
const resultado = document.getElementById("result");
const botonAutenticacion = document.getElementById("auth-btn");

// Detecta backend en el mismo host, puerto 8000
const URL_API = `http://${window.location.hostname}:8000`;

console.log(`Usando URL_API: ${URL_API}`);

async function iniciarCamara() {
    const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" } });
    videoElemento.srcObject = stream;
}

function capturarImagen() {
    return new Promise((resolve, reject) => {
        const contexto = lienzo.getContext("2d");
        const track = videoElemento.srcObject.getVideoTracks()[0];
        const settings = track.getSettings();

        lienzo.width = settings.width || videoElemento.videoWidth || 480;
        lienzo.height = settings.height || videoElemento.videoHeight || 360;

        contexto.drawImage(videoElemento, 0, 0, lienzo.width, lienzo.height);

        lienzo.toBlob((blob) => {
            if (!blob) {
                reject(new Error("No se pudo capturar la imagen"));
                return;
            }
            resolve(blob);
        }, "image/jpeg", 0.9);
    });
}

async function autenticarUnaVez() {
    const blob = await capturarImagen();
    const formData = new FormData();
    formData.append("file", blob, "captura.jpg");

    const response = await fetch(`${URL_API}/api/autenticar`, { method: "POST", body: formData });
    if (!response.ok) throw new Error(`Error en servidor: ${response.status}`);
    return await response.json();
}

botonAutenticacion.addEventListener("click", async () => {
    botonAutenticacion.disabled = true;
    resultado.textContent = "Autenticando...";
    resultado.parentElement.classList.remove("success", "error");
    resultado.parentElement.classList.add("loading");

    try {
        const intentos = [];
        let resultadoFinal = { autenticado: false };

        for (let i = 0; i < 10; i += 1) {
            const data = await autenticarUnaVez();
            intentos.push(data);

            if (data.autenticado === true) {
                resultadoFinal = data;
                break;
            }

            resultado.textContent = `Intento ${i + 1}/10...`;
            await new Promise((r) => setTimeout(r, 150));
        }

        const datosResultado = {
            autenticado: resultadoFinal.autenticado === true,
            intentos_realizados: intentos.length,
            confianza: resultadoFinal.detalles?.confianza.toFixed(2) || "N/A",
        };

        resultado.parentElement.classList.remove("loading");
        if (resultadoFinal.autenticado === true) {
            resultado.parentElement.classList.add("success");
            resultado.textContent = `¡Autenticación exitosa!\n\n${JSON.stringify(datosResultado, null, 2)}`;
        } else {
            resultado.parentElement.classList.add("error");
            resultado.textContent = `Autenticación fallida\n\n${JSON.stringify(datosResultado, null, 2)}`;
        }
    } catch (error) {
        resultado.parentElement.classList.remove("loading");
        resultado.parentElement.classList.add("error");
        resultado.textContent = `Error: ${error.message}`;
    } finally {
        botonAutenticacion.disabled = false;
    }
});

iniciarCamara().catch((error) => {
    resultado.textContent = `No se pudo acceder a la cámara: ${error.message}`;
});