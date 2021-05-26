let config = {}

function onError(error) {
 console.log(`Error: ${error}`);
}

let radios = document.getElementsByTagName("input")

function getConfig(){
    browser.storage.sync.get("config").then((response) =>{
        config = response.config || config
        for(let radio of radios){
            radio.checked = config[radio.name]
        }
    },onError)
}

function setConfig(){
    browser.storage.sync.set({config})
}

//browser.storage.sync.clear()
document.addEventListener("DOMContentLoaded", getConfig);


for(let radio of radios){
    radio.addEventListener("click",event=>{
        if(event.target.checked){
            config[event.target.name] = true
        }else {
            config[event.target.name] = false
        }
        setConfig()
    },false)
}
