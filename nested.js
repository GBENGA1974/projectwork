
function getObjectKeys(object, key) {

    const keys = key.split('.');
    let obj = object;
    for (let ikey of keys) {
        for (let [objKey, value] of Object.entries(obj)) {
            if(!keys.includes(objKey)) {
                continue;
            }
            obj = value;
        }
    }
    return obj;
}

// Set values of obj and key
var obj = {"x": { "y": { "z": "a" }}};
var key = 'x.y.z'

//Call function to see the output as the value a.
console.log(getObjectKeys(obj, key));