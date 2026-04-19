var WebGLImagePicker = {
    $ImagePickerContext: {
        gameObjectName: "",
        methodName: ""
    },

    OpenImagePickerPanel: function (gameObjectNamePtr, methodNamePtr) {
        ImagePickerContext.gameObjectName = UTF8ToString(gameObjectNamePtr);
        ImagePickerContext.methodName = UTF8ToString(methodNamePtr);

        var fileInput = document.getElementById('webgl-file-input');
        if (!fileInput) {
            fileInput = document.createElement('input');
            fileInput.setAttribute('type', 'file');
            fileInput.setAttribute('id', 'webgl-file-input');
            fileInput.setAttribute('accept', 'image/*');
            fileInput.style.display = 'none';

            fileInput.onchange = function (event) {
                if (event.target.files.length === 0) return;
                var file = event.target.files[0];
                var url = URL.createObjectURL(file);
                SendMessage(ImagePickerContext.gameObjectName, ImagePickerContext.methodName, url);
                fileInput.value = ""; // Reset
            };

            document.body.appendChild(fileInput);
        }

        fileInput.click();
    }
};

autoAddDeps(WebGLImagePicker, '$ImagePickerContext');
mergeInto(LibraryManager.library, WebGLImagePicker);
