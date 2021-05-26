browser.runtime.onMessage.addListener((request, sender, sendResponse)=>{
    if (request.type === "query"){
        console.log(request.content)
        browser.runtime.sendNativeMessage(request.content).then(response=>{
            console.log(response)
            sendResponse(response) })
        return true
    }
});
