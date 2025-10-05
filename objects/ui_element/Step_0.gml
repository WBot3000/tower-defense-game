/// @description Prevent UI elements from doing anything while invisible
if(!visible || !layer_get_visible(layer)) { return; } //If the UI element isn't visible, don't run any step code.

//This should be handled by disabling the element's respective UI layer, but it's kind of buggy so this will have to do for now.
//NOTE: You can't just call event_inherited() in the UI elements, you have to actually copy-paste the line of code above (because of how function calls work)