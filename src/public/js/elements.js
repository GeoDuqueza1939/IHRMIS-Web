"use strict";
const NO_NS = "NO NAMESPACE";

/**
 * Create a simple element
 * @author Geovani P. Duqueza
 * @version 1.01
 * @param {String} xmlns Namespace URI
 * @param {String} elName Element name
 * @param {String} className Class attribute value
 * @param {Element} parent Parent element/node
 * @param {Element} nextNode Next sibling element/node
 * @throws {Error} "Element name cannot be empty."
 * @returns {Element}
 */
function createSimpleElement(xmlns, elName, className, parent)
{
    let el = null;
    if (elName == "" || elName == null || elName == undefined)
        throw("Element name cannot be empty.");
    else {
        el = (xmlns == "" || xmlns == NO_NS ? document.createElement(elName.toUpperCase()) : document.createElementNS(xmlns, elName));

        if (className != "" && className != null && className != undefined)
            el.setAttribute("class", className);
    
        if (parent != null && parent != undefined) {
            if (arguments.length == 5)
                parent.insertBefore(el, arguments[4]);
            else
                parent.appendChild(el);
        }
    }

    return el;
}

/**
 * Creates an element with attributes
 * @author Geovani P. Duqueza
 * @version 1.01
 * @param {String} xmlns Namespace URI
 * @param {String} elName Element name
 * @param {Element} parent Parent element/node
 * @param {Element} nextNode Next sibling element/node
 * @param {String} ..arguments 
 * @throws {Error} "Element name cannot be empty."
 * @returns {Element}
 */
function createElementEx(xmlns, elName, parent, nextNode)
{   // args: xmlns, elName, parent, nextNode, argNS1, argName1, argVal1, argNS2, argName2, argVal2, ...
    let el = null;
    if (elName == "" || elName == null || elName == undefined)
        throw("Element name cannot be empty.");
    else {
        el = (xmlns == "" || xmlns == NO_NS ? document.createElement(elName.toUpperCase()) : document.createElementNS(xmlns, elName));

        if (arguments.length > 4) {
            if (arguments[0] == NO_NS || arguments[4] == NO_NS) {
                for (let i = 4 + (arguments[4] == NO_NS ? 1 : 0), length = arguments.length - (arguments.length + (arguments[4] == NO_NS ? 1 : 0)) % 2; i < length; i++) {
                    el.setAttribute(arguments[i++], arguments[i]);
                }
            }
            else { // ignore last attribute if it has no paired value
                for (let i = 4, length = arguments.length - (arguments.length + 2) % 3; i < length; i++) {
                    if (arguments[i] != "" || arguments[i] != null || arguments[i] != undefined)
                        el.setAttributeNS(arguments[i], arguments[++i], arguments[++i]);
                    else
                        el.setAttribute(arguments[++i], arguments[++i]);
                }
            }
        }

        if (parent != null && parent != undefined) {
            if (nextNode == null || nextNode == undefined)
                parent.appendChild(el);
            else
                parent.insertBefore(el, nextNode);
        }
    }

    return el;
}

/**
 * Adds text to the specified container
 * @param {String} text The text to be added.
 * @param {Element} container The element that would contain the text.
 * @param {Node} nextSibling (optional) The element/node that should come after the text.
 * @throws {Error} "Incorrect number of arguments."
 * @throws {Error} "Container element cannot be null or undefined."
 */
function addText(text, container, nextSibling = null)
{
    let textNode = null;
    if (arguments.length < 2 || arguments.length > 3) {
        throw("Incorrect number of arguments.");
    }
    else if (container == null || container == undefined) {
        throw("Container element cannot be null or undefined.");
    }
    else {
        textNode = document.createTextNode(text);
        if (nextSibling == null || nextSibling == undefined)
            container.appendChild(textNode);
        else
            container.insertBefore(textNode, nextSibling);
    }

    return textNode;
}

/**
 * @param {String} HTML representing a single element
 * @return {Element}
 *      source: https://stackoverflow.com/a/35385518
 */
function htmlToElement(html) {
    const TEMPLATE = document.createElement("template");
    html = html.trim(); // Never return a text node of whitespace as the result
    TEMPLATE.innerHTML = html;
    return TEMPLATE.content.firstChild;
}

/**
 * @param {String} HTML representing any number of sibling elements
 * @return {NodeList} 
 *      source: https://stackoverflow.com/a/35385518
 */
function htmlToElements(html) {
    const TEMPLATE = document.createElement("template");
    TEMPLATE.innerHTML = html;
    return TEMPLATE.content.childNodes;
}

/**
 * @param {*} element 
 * @return {Boolean}
 *      source: https://stackoverflow.com/a/36894871
 */
function isElement(element) {
    return element instanceof Element || element instanceof HTMLDocument || type(element).includes("element");
}

// export { NO_NS, createSimpleElement, createElementEx, addText, htmlToElement, htmlToElements, isElement }
