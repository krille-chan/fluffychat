let wasm_bindgen;
(function() {
    const __exports = {};
    let script_src;
    if (typeof document !== 'undefined' && document.currentScript !== null) {
        script_src = new URL(document.currentScript.src, location.href).toString();
    }
    let wasm = undefined;

    function addToExternrefTable0(obj) {
        const idx = wasm.__externref_table_alloc();
        wasm.__wbindgen_export_2.set(idx, obj);
        return idx;
    }

    function handleError(f, args) {
        try {
            return f.apply(this, args);
        } catch (e) {
            const idx = addToExternrefTable0(e);
            wasm.__wbindgen_exn_store(idx);
        }
    }

    let WASM_VECTOR_LEN = 0;

    let cachedUint8ArrayMemory0 = null;

    function getUint8ArrayMemory0() {
        if (cachedUint8ArrayMemory0 === null || cachedUint8ArrayMemory0.byteLength === 0) {
            cachedUint8ArrayMemory0 = new Uint8Array(wasm.memory.buffer);
        }
        return cachedUint8ArrayMemory0;
    }

    const cachedTextEncoder = (typeof TextEncoder !== 'undefined' ? new TextEncoder('utf-8') : { encode: () => { throw Error('TextEncoder not available') } } );

    const encodeString = (typeof cachedTextEncoder.encodeInto === 'function'
        ? function (arg, view) {
        return cachedTextEncoder.encodeInto(arg, view);
    }
        : function (arg, view) {
        const buf = cachedTextEncoder.encode(arg);
        view.set(buf);
        return {
            read: arg.length,
            written: buf.length
        };
    });

    function passStringToWasm0(arg, malloc, realloc) {

        if (realloc === undefined) {
            const buf = cachedTextEncoder.encode(arg);
            const ptr = malloc(buf.length, 1) >>> 0;
            getUint8ArrayMemory0().subarray(ptr, ptr + buf.length).set(buf);
            WASM_VECTOR_LEN = buf.length;
            return ptr;
        }

        let len = arg.length;
        let ptr = malloc(len, 1) >>> 0;

        const mem = getUint8ArrayMemory0();

        let offset = 0;

        for (; offset < len; offset++) {
            const code = arg.charCodeAt(offset);
            if (code > 0x7F) break;
            mem[ptr + offset] = code;
        }

        if (offset !== len) {
            if (offset !== 0) {
                arg = arg.slice(offset);
            }
            ptr = realloc(ptr, len, len = offset + arg.length * 3, 1) >>> 0;
            const view = getUint8ArrayMemory0().subarray(ptr + offset, ptr + len);
            const ret = encodeString(arg, view);

            offset += ret.written;
            ptr = realloc(ptr, len, offset, 1) >>> 0;
        }

        WASM_VECTOR_LEN = offset;
        return ptr;
    }

    let cachedDataViewMemory0 = null;

    function getDataViewMemory0() {
        if (cachedDataViewMemory0 === null || cachedDataViewMemory0.buffer.detached === true || (cachedDataViewMemory0.buffer.detached === undefined && cachedDataViewMemory0.buffer !== wasm.memory.buffer)) {
            cachedDataViewMemory0 = new DataView(wasm.memory.buffer);
        }
        return cachedDataViewMemory0;
    }

    const cachedTextDecoder = (typeof TextDecoder !== 'undefined' ? new TextDecoder('utf-8', { ignoreBOM: true, fatal: true }) : { decode: () => { throw Error('TextDecoder not available') } } );

    if (typeof TextDecoder !== 'undefined') { cachedTextDecoder.decode(); };

    function getStringFromWasm0(ptr, len) {
        ptr = ptr >>> 0;
        return cachedTextDecoder.decode(getUint8ArrayMemory0().subarray(ptr, ptr + len));
    }

    function isLikeNone(x) {
        return x === undefined || x === null;
    }

    const CLOSURE_DTORS = (typeof FinalizationRegistry === 'undefined')
        ? { register: () => {}, unregister: () => {} }
        : new FinalizationRegistry(state => {
        wasm.__wbindgen_export_6.get(state.dtor)(state.a, state.b)
    });

    function makeMutClosure(arg0, arg1, dtor, f) {
        const state = { a: arg0, b: arg1, cnt: 1, dtor };
        const real = (...args) => {
            // First up with a closure we increment the internal reference
            // count. This ensures that the Rust closure environment won't
            // be deallocated while we're invoking it.
            state.cnt++;
            const a = state.a;
            state.a = 0;
            try {
                return f(a, state.b, ...args);
            } finally {
                if (--state.cnt === 0) {
                    wasm.__wbindgen_export_6.get(state.dtor)(a, state.b);
                    CLOSURE_DTORS.unregister(state);
                } else {
                    state.a = a;
                }
            }
        };
        real.original = state;
        CLOSURE_DTORS.register(real, state, state);
        return real;
    }

    function debugString(val) {
        // primitive types
        const type = typeof val;
        if (type == 'number' || type == 'boolean' || val == null) {
            return  `${val}`;
        }
        if (type == 'string') {
            return `"${val}"`;
        }
        if (type == 'symbol') {
            const description = val.description;
            if (description == null) {
                return 'Symbol';
            } else {
                return `Symbol(${description})`;
            }
        }
        if (type == 'function') {
            const name = val.name;
            if (typeof name == 'string' && name.length > 0) {
                return `Function(${name})`;
            } else {
                return 'Function';
            }
        }
        // objects
        if (Array.isArray(val)) {
            const length = val.length;
            let debug = '[';
            if (length > 0) {
                debug += debugString(val[0]);
            }
            for(let i = 1; i < length; i++) {
                debug += ', ' + debugString(val[i]);
            }
            debug += ']';
            return debug;
        }
        // Test for built-in
        const builtInMatches = /\[object ([^\]]+)\]/.exec(toString.call(val));
        let className;
        if (builtInMatches && builtInMatches.length > 1) {
            className = builtInMatches[1];
        } else {
            // Failed to match the standard '[object ClassName]'
            return toString.call(val);
        }
        if (className == 'Object') {
            // we're a user defined class or Object
            // JSON.stringify avoids problems with cycles, and is generally much
            // easier than looping through ownProperties of `val`.
            try {
                return 'Object(' + JSON.stringify(val) + ')';
            } catch (_) {
                return 'Object';
            }
        }
        // errors
        if (val instanceof Error) {
            return `${val.name}: ${val.message}\n${val.stack}`;
        }
        // TODO we could test for more things here, like `Set`s and `Map`s.
        return className;
    }
    /**
     * @returns {number}
     */
    __exports.frb_get_rust_content_hash = function() {
        const ret = wasm.frb_get_rust_content_hash();
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_fallback_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_fallback_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_forget_fallback_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_forget_fallback_key(that);
        return ret;
    };

    function passArray8ToWasm0(arg, malloc) {
        const ptr = malloc(arg.length * 1, 1) >>> 0;
        getUint8ArrayMemory0().set(arg, ptr / 1);
        WASM_VECTOR_LEN = arg.length;
        return ptr;
    }
    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_from_olm_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} public_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_remove_one_time_key = function(that, public_key) {
        const ptr0 = passStringToWasm0(public_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_remove_one_time_key(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} message
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_sign = function(that, message) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_sign(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_curve_25519_public_key_as_bytes = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_as_bytes(that);
        return ret;
    };

    /**
     * @param {string} base64_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_curve_25519_public_key_from_base64 = function(base64_key) {
        const ptr0 = passStringToWasm0(base64_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_from_base64(ptr0, len0);
        return ret;
    };

    /**
     * @param {Uint8Array} bytes
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_curve_25519_public_key_from_slice = function(bytes) {
        const ptr0 = passArray8ToWasm0(bytes, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_from_slice(ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_curve_25519_public_key_to_base64 = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_to_base64(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_public_key_as_bytes = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_as_bytes(that);
        return ret;
    };

    /**
     * @param {string} base64_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_public_key_from_base64 = function(base64_key) {
        const ptr0 = passStringToWasm0(base64_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_from_base64(ptr0, len0);
        return ret;
    };

    /**
     * @param {Uint8Array} bytes
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_public_key_from_slice = function(bytes) {
        const ptr0 = passArray8ToWasm0(bytes, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_from_slice(ptr0, len0);
        return ret;
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_from_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_generate_fallback_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_generate_fallback_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {any} count
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_generate_one_time_keys = function(that, count) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_generate_one_time_keys(that, count);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_identity_keys = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_identity_keys(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_mark_keys_as_published = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_mark_keys_as_published(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_max_number_of_one_time_keys = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_max_number_of_one_time_keys(that);
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_new = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_account_new();
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_one_time_keys = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_one_time_keys(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_pickle_encrypted = function(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_pickle_encrypted(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_public_key_to_base64 = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_to_base64(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} message
     * @param {any} signature
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_public_key_verify = function(that, message, signature) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_verify(that, ptr0, len0, signature);
        return ret;
    };

    /**
     * @param {string} signature
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_signature_from_base64 = function(signature) {
        const ptr0 = passStringToWasm0(signature, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_from_base64(ptr0, len0);
        return ret;
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_from_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_message_index = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_message_index(that);
        return ret;
    };

    /**
     * @param {any} config
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_new = function(config) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_new(config);
        return ret;
    };

    /**
     * @param {any} that
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_pickle_encrypted = function(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_pickle_encrypted(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_session_config = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_session_config(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_session_id = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_session_id(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_session_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_session_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_to_inbound = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_to_inbound(that);
        return ret;
    };

    /**
     * @param {Uint8Array} bytes
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_signature_from_slice = function(bytes) {
        const ptr0 = passArray8ToWasm0(bytes, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_from_slice(ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_signature_to_base64 = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_to_base64(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_ed_25519_signature_to_bytes = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_to_bytes(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} input
     * @param {string} info
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_established_sas_calculate_mac = function(that, input, info) {
        const ptr0 = passStringToWasm0(input, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_calculate_mac(that, ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} input
     * @param {string} info
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_established_sas_calculate_mac_deprecated = function(that, input, info) {
        const ptr0 = passStringToWasm0(input, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_calculate_mac_deprecated(that, ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} info
     * @param {number} length
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_established_sas_generate_bytes = function(that, info, length) {
        const ptr0 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_generate_bytes(that, ptr0, len0, length);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} input
     * @param {string} info
     * @param {string} mac
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_established_sas_verify_mac = function(that, input, info, mac) {
        const ptr0 = passStringToWasm0(input, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len1 = WASM_VECTOR_LEN;
        const ptr2 = passStringToWasm0(mac, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len2 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_verify_mac(that, ptr0, len0, ptr1, len1, ptr2, len2);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} plaintext
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_encrypt = function(that, plaintext) {
        const ptr0 = passStringToWasm0(plaintext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_encrypt(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_group_session_from_olm_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} encrypted
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_decrypt = function(that, encrypted) {
        const ptr0 = passStringToWasm0(encrypted, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_decrypt(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @param {number} index
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_export_at = function(that, index) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_export_at(that, index);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_export_at_first_known_index = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_export_at_first_known_index(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_first_known_index = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_first_known_index(that);
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_megolm_session_config_version_1 = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_megolm_session_config_version_1();
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_megolm_session_config_version_2 = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_megolm_session_config_version_2();
        return ret;
    };

    /**
     * @param {any} message_type
     * @param {string} ciphertext
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_olm_message_from_parts = function(message_type, ciphertext) {
        const ptr0 = passStringToWasm0(ciphertext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_olm_message_from_parts(message_type, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_olm_message_message = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_message_message(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_olm_message_message_type = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_message_message_type(that);
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_olm_session_config_def = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_session_config_def();
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_olm_session_config_version = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_session_config_version(that);
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_olm_session_config_version_1 = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_session_config_version_1();
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_olm_session_config_version_2 = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_session_config_version_2();
        return ret;
    };

    /**
     * @param {number} func_id
     * @param {any} port_
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     */
    __exports.frb_pde_ffi_dispatcher_primary = function(func_id, port_, ptr_, rust_vec_len_, data_len_) {
        wasm.frb_pde_ffi_dispatcher_primary(func_id, port_, ptr_, rust_vec_len_, data_len_);
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_from_olm_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_from_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {string} exported_session_key
     * @param {any} config
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_import = function(exported_session_key, config) {
        const ptr0 = passStringToWasm0(exported_session_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_import(ptr0, len0, config);
        return ret;
    };

    /**
     * @param {string} session_key
     * @param {any} config
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_new = function(session_key, config) {
        const ptr0 = passStringToWasm0(session_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_new(ptr0, len0, config);
        return ret;
    };

    /**
     * @param {any} that
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_pickle_encrypted = function(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_pickle_encrypted(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_inbound_group_session_session_id = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_session_id(that);
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_megolm_session_config_def = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_megolm_session_config_def();
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_megolm_session_config_version = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_megolm_session_config_version(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {any} message
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_decryption_decrypt = function(that, message) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_decrypt(that, message);
        return ret;
    };

    /**
     * @param {Uint8Array} secret_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_decryption_from_key = function(secret_key) {
        const ptr0 = passArray8ToWasm0(secret_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_from_key(ptr0, len0);
        return ret;
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_decryption_from_libolm_pickle = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_from_libolm_pickle(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @param {any} message
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_decrypt = function(that, message) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_decrypt(that, message);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} plaintext
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_encrypt = function(that, plaintext) {
        const ptr0 = passStringToWasm0(plaintext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_session_encrypt(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_from_olm_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_session_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {string} pickle
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_from_pickle_encrypted = function(pickle, pickle_key) {
        const ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_session_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_has_received_message = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_has_received_message(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_pickle_encrypted = function(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_session_pickle_encrypted(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_session_config = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_session_config(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_session_session_id = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_session_id(that);
        return ret;
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_decryption_new = function() {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_new();
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_decryption_private_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_private_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_decryption_public_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_public_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {Uint8Array} pickle_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_decryption_to_libolm_pickle = function(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_to_libolm_pickle(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} message
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_encryption_encrypt = function(that, message) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_encryption_encrypt(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} public_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_encryption_from_key = function(public_key) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_encryption_from_key(public_key);
        return ret;
    };

    /**
     * @param {string} ciphertext
     * @param {string} mac
     * @param {string} ephemeral_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_message_from_base64 = function(ciphertext, mac, ephemeral_key) {
        const ptr0 = passStringToWasm0(ciphertext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passStringToWasm0(mac, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len1 = WASM_VECTOR_LEN;
        const ptr2 = passStringToWasm0(ephemeral_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len2 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_message_from_base64(ptr0, len0, ptr1, len1, ptr2, len2);
        return ret;
    };

    /**
     * @param {Uint8Array} ciphertext
     * @param {Uint8Array} mac
     * @param {any} ephemeral_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_message_new = function(ciphertext, mac, ephemeral_key) {
        const ptr0 = passArray8ToWasm0(ciphertext, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(mac, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_message_new(ptr0, len0, ptr1, len1, ephemeral_key);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_pk_message_to_base64 = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_message_to_base64(that);
        return ret;
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_Curve25519PublicKey = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_Ed25519PublicKey = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_Ed25519PublicKey = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_Ed25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_OlmSessionConfig = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_OlmSessionConfig(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_PkDecryption = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_PkDecryption = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_PkDecryption(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_PkEncryption = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_PkEncryption = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_PkEncryption(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_RwLockGroupSession = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_RwLockGroupSession = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_RwLockGroupSession(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_RwLockInboundGroupSession = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_Ed25519Signature = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_Ed25519Signature = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_Ed25519Signature(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_EstablishedSas = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_EstablishedSas = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_EstablishedSas(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_MegolmSessionConfig = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_MegolmSessionConfig = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_MegolmSessionConfig(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_OlmMessage = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_OlmMessage = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_OlmMessage(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_OlmSessionConfig = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_RwLockInboundGroupSession = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_RwLockInboundGroupSession(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_RwLockSession = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_RwLockSession = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_RwLockSession(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} func_id
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     * @returns {any}
     */
    __exports.frb_pde_ffi_dispatcher_sync = function(func_id, ptr_, rust_vec_len_, data_len_) {
        const ret = wasm.frb_pde_ffi_dispatcher_sync(func_id, ptr_, rust_vec_len_, data_len_);
        return ret;
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_increment_strong_count_RustOpaque_stdsyncRwLockAccount = function(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    };

    /**
     * @param {number} ptr
     */
    __exports.rust_arc_decrement_strong_count_RustOpaque_stdsyncRwLockAccount = function(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_stdsyncRwLockAccount(ptr);
    };

    /**
     * @param {number} call_id
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     */
    __exports.frb_dart_fn_deliver_output = function(call_id, ptr_, rust_vec_len_, data_len_) {
        wasm.frb_dart_fn_deliver_output(call_id, ptr_, rust_vec_len_, data_len_);
    };

    /**
     * @param {Uint8Array} input
     * @param {Uint8Array} key
     * @param {Uint8Array} iv
     * @returns {any}
     */
    __exports.wire__crate__bindings__aes_ctr = function(input, key, iv) {
        const ptr0 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(key, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ptr2 = passArray8ToWasm0(iv, wasm.__wbindgen_malloc);
        const len2 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__aes_ctr(ptr0, len0, ptr1, len1, ptr2, len2);
        return ret;
    };

    /**
     * @param {Uint8Array} key
     * @param {Uint8Array} input
     * @returns {any}
     */
    __exports.wire__crate__bindings__hmac = function(key, input) {
        const ptr0 = passArray8ToWasm0(key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__hmac(ptr0, len0, ptr1, len1);
        return ret;
    };

    /**
     * @param {Uint8Array} passphrase
     * @param {Uint8Array} salt
     * @param {number} iterations
     * @returns {any}
     */
    __exports.wire__crate__bindings__pbkdf2 = function(passphrase, salt, iterations) {
        const ptr0 = passArray8ToWasm0(passphrase, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ptr1 = passArray8ToWasm0(salt, wasm.__wbindgen_malloc);
        const len1 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__pbkdf2(ptr0, len0, ptr1, len1, iterations);
        return ret;
    };

    /**
     * @param {Uint8Array} input
     * @returns {any}
     */
    __exports.wire__crate__bindings__sha256 = function(input) {
        const ptr0 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__sha256(ptr0, len0);
        return ret;
    };

    /**
     * @param {Uint8Array} input
     * @returns {any}
     */
    __exports.wire__crate__bindings__sha512 = function(input) {
        const ptr0 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__sha512(ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @param {any} their_identity_key
     * @param {string} pre_key_message_base64
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_create_inbound_session = function(that, their_identity_key, pre_key_message_base64) {
        const ptr0 = passStringToWasm0(pre_key_message_base64, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_create_inbound_session(that, their_identity_key, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @param {any} config
     * @param {any} identity_key
     * @param {any} one_time_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_create_outbound_session = function(that, config, identity_key, one_time_key) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_create_outbound_session(that, config, identity_key, one_time_key);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_curve25519_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_curve25519_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__vodozemac_account_ed25519_key = function(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_ed25519_key(that);
        return ret;
    };

    /**
     * @param {string} key
     * @returns {any}
     */
    __exports.wire__crate__bindings__PkSigning_from_secret_key = function(key) {
        const ptr0 = passStringToWasm0(key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__PkSigning_from_secret_key(ptr0, len0);
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__PkSigning_new = function() {
        const ret = wasm.wire__crate__bindings__PkSigning_new();
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__PkSigning_public_key = function(that) {
        const ret = wasm.wire__crate__bindings__PkSigning_public_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__PkSigning_secret_key = function(that) {
        const ret = wasm.wire__crate__bindings__PkSigning_secret_key(that);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} message
     * @returns {any}
     */
    __exports.wire__crate__bindings__PkSigning_sign = function(that, message) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__PkSigning_sign(that, ptr0, len0);
        return ret;
    };

    /**
     * @param {any} that
     * @param {string} other_public_key
     * @returns {any}
     */
    __exports.wire__crate__bindings__VodozemacSas_establish_sas_secret = function(that, other_public_key) {
        const ptr0 = passStringToWasm0(other_public_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__VodozemacSas_establish_sas_secret(that, ptr0, len0);
        return ret;
    };

    /**
     * @returns {any}
     */
    __exports.wire__crate__bindings__VodozemacSas_new = function() {
        const ret = wasm.wire__crate__bindings__VodozemacSas_new();
        return ret;
    };

    /**
     * @param {any} that
     * @returns {any}
     */
    __exports.wire__crate__bindings__VodozemacSas_public_key = function(that) {
        const ret = wasm.wire__crate__bindings__VodozemacSas_public_key(that);
        return ret;
    };

    function passArrayJsValueToWasm0(array, malloc) {
        const ptr = malloc(array.length * 4, 4) >>> 0;
        for (let i = 0; i < array.length; i++) {
            const add = addToExternrefTable0(array[i]);
            getDataViewMemory0().setUint32(ptr + 4 * i, add, true);
        }
        WASM_VECTOR_LEN = array.length;
        return ptr;
    }

    function takeFromExternrefTable0(idx) {
        const value = wasm.__wbindgen_export_2.get(idx);
        wasm.__externref_table_dealloc(idx);
        return value;
    }
    /**
     * ## Safety
     * This function reclaims a raw pointer created by [`TransferClosure`], and therefore
     * should **only** be used in conjunction with it.
     * Furthermore, the WASM module in the worker must have been initialized with the shared
     * memory from the host JS scope.
     * @param {number} payload
     * @param {any[]} transfer
     */
    __exports.receive_transfer_closure = function(payload, transfer) {
        const ptr0 = passArrayJsValueToWasm0(transfer, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.receive_transfer_closure(payload, ptr0, len0);
        if (ret[1]) {
            throw takeFromExternrefTable0(ret[0]);
        }
    };

    /**
     * # Safety
     *
     * This should never be called manually.
     * @param {any} handle
     * @param {any} dart_handler_port
     * @returns {number}
     */
    __exports.frb_dart_opaque_dart2rust_encode = function(handle, dart_handler_port) {
        const ret = wasm.frb_dart_opaque_dart2rust_encode(handle, dart_handler_port);
        return ret >>> 0;
    };

    /**
     * @param {number} ptr
     * @returns {any}
     */
    __exports.frb_dart_opaque_rust2dart_decode = function(ptr) {
        const ret = wasm.frb_dart_opaque_rust2dart_decode(ptr);
        return ret;
    };

    /**
     * @param {number} ptr
     */
    __exports.frb_dart_opaque_drop_thread_box_persistent_handle = function(ptr) {
        wasm.frb_dart_opaque_drop_thread_box_persistent_handle(ptr);
    };

    __exports.wasm_start_callback = function() {
        wasm.wasm_start_callback();
    };

    function __wbg_adapter_40(arg0, arg1, arg2) {
        wasm.closure582_externref_shim(arg0, arg1, arg2);
    }

    const WorkerPoolFinalization = (typeof FinalizationRegistry === 'undefined')
        ? { register: () => {}, unregister: () => {} }
        : new FinalizationRegistry(ptr => wasm.__wbg_workerpool_free(ptr >>> 0, 1));

    class WorkerPool {

        static __wrap(ptr) {
            ptr = ptr >>> 0;
            const obj = Object.create(WorkerPool.prototype);
            obj.__wbg_ptr = ptr;
            WorkerPoolFinalization.register(obj, obj.__wbg_ptr, obj);
            return obj;
        }

        __destroy_into_raw() {
            const ptr = this.__wbg_ptr;
            this.__wbg_ptr = 0;
            WorkerPoolFinalization.unregister(this);
            return ptr;
        }

        free() {
            const ptr = this.__destroy_into_raw();
            wasm.__wbg_workerpool_free(ptr, 0);
        }
        /**
         * @param {number | null} [initial]
         * @param {string | null} [script_src]
         * @param {string | null} [worker_js_preamble]
         * @returns {WorkerPool}
         */
        static new(initial, script_src, worker_js_preamble) {
            var ptr0 = isLikeNone(script_src) ? 0 : passStringToWasm0(script_src, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            var len0 = WASM_VECTOR_LEN;
            var ptr1 = isLikeNone(worker_js_preamble) ? 0 : passStringToWasm0(worker_js_preamble, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            var len1 = WASM_VECTOR_LEN;
            const ret = wasm.workerpool_new(isLikeNone(initial) ? 0x100000001 : (initial) >>> 0, ptr0, len0, ptr1, len1);
            if (ret[2]) {
                throw takeFromExternrefTable0(ret[1]);
            }
            return WorkerPool.__wrap(ret[0]);
        }
        /**
         * Creates a new `WorkerPool` which immediately creates `initial` workers.
         *
         * The pool created here can be used over a long period of time, and it
         * will be initially primed with `initial` workers. Currently workers are
         * never released or gc'd until the whole pool is destroyed.
         *
         * # Errors
         *
         * Returns any error that may happen while a JS web worker is created and a
         * message is sent to it.
         * @param {number} initial
         * @param {string} script_src
         * @param {string} worker_js_preamble
         */
        constructor(initial, script_src, worker_js_preamble) {
            const ptr0 = passStringToWasm0(script_src, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len0 = WASM_VECTOR_LEN;
            const ptr1 = passStringToWasm0(worker_js_preamble, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            const ret = wasm.workerpool_new_raw(initial, ptr0, len0, ptr1, len1);
            if (ret[2]) {
                throw takeFromExternrefTable0(ret[1]);
            }
            this.__wbg_ptr = ret[0] >>> 0;
            WorkerPoolFinalization.register(this, this.__wbg_ptr, this);
            return this;
        }
    }
    __exports.WorkerPool = WorkerPool;

    async function __wbg_load(module, imports) {
        if (typeof Response === 'function' && module instanceof Response) {
            if (typeof WebAssembly.instantiateStreaming === 'function') {
                try {
                    return await WebAssembly.instantiateStreaming(module, imports);

                } catch (e) {
                    if (module.headers.get('Content-Type') != 'application/wasm') {
                        console.warn("`WebAssembly.instantiateStreaming` failed because your server does not serve Wasm with `application/wasm` MIME type. Falling back to `WebAssembly.instantiate` which is slower. Original error:\n", e);

                    } else {
                        throw e;
                    }
                }
            }

            const bytes = await module.arrayBuffer();
            return await WebAssembly.instantiate(bytes, imports);

        } else {
            const instance = await WebAssembly.instantiate(module, imports);

            if (instance instanceof WebAssembly.Instance) {
                return { instance, module };

            } else {
                return instance;
            }
        }
    }

    function __wbg_get_imports() {
        const imports = {};
        imports.wbg = {};
        imports.wbg.__wbg_buffer_609cc3eee51ed158 = function(arg0) {
            const ret = arg0.buffer;
            return ret;
        };
        imports.wbg.__wbg_call_672a4d21634d4a24 = function() { return handleError(function (arg0, arg1) {
            const ret = arg0.call(arg1);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_call_7cccdd69e0791ae2 = function() { return handleError(function (arg0, arg1, arg2) {
            const ret = arg0.call(arg1, arg2);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_createObjectURL_6e98d2f9c7bd9764 = function() { return handleError(function (arg0, arg1) {
            const ret = URL.createObjectURL(arg1);
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        }, arguments) };
        imports.wbg.__wbg_crypto_ed58b8e10a292839 = function(arg0) {
            const ret = arg0.crypto;
            return ret;
        };
        imports.wbg.__wbg_data_432d9c3df2630942 = function(arg0) {
            const ret = arg0.data;
            return ret;
        };
        imports.wbg.__wbg_error_076d4beefd7cfd14 = function(arg0, arg1) {
            console.error(getStringFromWasm0(arg0, arg1));
        };
        imports.wbg.__wbg_error_7534b8e9a36f1ab4 = function(arg0, arg1) {
            let deferred0_0;
            let deferred0_1;
            try {
                deferred0_0 = arg0;
                deferred0_1 = arg1;
                console.error(getStringFromWasm0(arg0, arg1));
            } finally {
                wasm.__wbindgen_free(deferred0_0, deferred0_1, 1);
            }
        };
        imports.wbg.__wbg_eval_e10dc02e9547f640 = function() { return handleError(function (arg0, arg1) {
            const ret = eval(getStringFromWasm0(arg0, arg1));
            return ret;
        }, arguments) };
        imports.wbg.__wbg_getRandomValues_bcb4912f16000dc4 = function() { return handleError(function (arg0, arg1) {
            arg0.getRandomValues(arg1);
        }, arguments) };
        imports.wbg.__wbg_get_67b2ba62fc30de12 = function() { return handleError(function (arg0, arg1) {
            const ret = Reflect.get(arg0, arg1);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_get_b9b93047fe3cf45b = function(arg0, arg1) {
            const ret = arg0[arg1 >>> 0];
            return ret;
        };
        imports.wbg.__wbg_instanceof_BroadcastChannel_102292ddffa430f7 = function(arg0) {
            let result;
            try {
                result = arg0 instanceof BroadcastChannel;
            } catch (_) {
                result = false;
            }
            const ret = result;
            return ret;
        };
        imports.wbg.__wbg_instanceof_ErrorEvent_24a579ed4d838fe9 = function(arg0) {
            let result;
            try {
                result = arg0 instanceof ErrorEvent;
            } catch (_) {
                result = false;
            }
            const ret = result;
            return ret;
        };
        imports.wbg.__wbg_instanceof_MessageEvent_2e467ced55f682c9 = function(arg0) {
            let result;
            try {
                result = arg0 instanceof MessageEvent;
            } catch (_) {
                result = false;
            }
            const ret = result;
            return ret;
        };
        imports.wbg.__wbg_isArray_a1eab7e0d067391b = function(arg0) {
            const ret = Array.isArray(arg0);
            return ret;
        };
        imports.wbg.__wbg_length_a446193dc22c12f8 = function(arg0) {
            const ret = arg0.length;
            return ret;
        };
        imports.wbg.__wbg_length_e2d2a49132c1b256 = function(arg0) {
            const ret = arg0.length;
            return ret;
        };
        imports.wbg.__wbg_message_d1685a448ba00178 = function(arg0, arg1) {
            const ret = arg1.message;
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        };
        imports.wbg.__wbg_msCrypto_0a36e2ec3a343d26 = function(arg0) {
            const ret = arg0.msCrypto;
            return ret;
        };
        imports.wbg.__wbg_name_235b92ab39fceaf8 = function(arg0, arg1) {
            const ret = arg1.name;
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        };
        imports.wbg.__wbg_new_405e22f390576ce2 = function() {
            const ret = new Object();
            return ret;
        };
        imports.wbg.__wbg_new_78feb108b6472713 = function() {
            const ret = new Array();
            return ret;
        };
        imports.wbg.__wbg_new_7f19378ebfdc87d5 = function() { return handleError(function (arg0, arg1) {
            const ret = new BroadcastChannel(getStringFromWasm0(arg0, arg1));
            return ret;
        }, arguments) };
        imports.wbg.__wbg_new_8a6f238a6ece86ea = function() {
            const ret = new Error();
            return ret;
        };
        imports.wbg.__wbg_new_a12002a7f91c75be = function(arg0) {
            const ret = new Uint8Array(arg0);
            return ret;
        };
        imports.wbg.__wbg_new_b1a33e5095abf678 = function() { return handleError(function (arg0, arg1) {
            const ret = new Worker(getStringFromWasm0(arg0, arg1));
            return ret;
        }, arguments) };
        imports.wbg.__wbg_newnoargs_105ed471475aaf50 = function(arg0, arg1) {
            const ret = new Function(getStringFromWasm0(arg0, arg1));
            return ret;
        };
        imports.wbg.__wbg_newwithblobsequenceandoptions_1db4479a1a2d4229 = function() { return handleError(function (arg0, arg1) {
            const ret = new Blob(arg0, arg1);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_newwithbyteoffsetandlength_d97e637ebe145a9a = function(arg0, arg1, arg2) {
            const ret = new Uint8Array(arg0, arg1 >>> 0, arg2 >>> 0);
            return ret;
        };
        imports.wbg.__wbg_newwithlength_a381634e90c276d4 = function(arg0) {
            const ret = new Uint8Array(arg0 >>> 0);
            return ret;
        };
        imports.wbg.__wbg_node_02999533c4ea02e3 = function(arg0) {
            const ret = arg0.node;
            return ret;
        };
        imports.wbg.__wbg_postMessage_33814d4dc32c2dcf = function() { return handleError(function (arg0, arg1) {
            arg0.postMessage(arg1);
        }, arguments) };
        imports.wbg.__wbg_postMessage_6edafa8f7b9c2f52 = function() { return handleError(function (arg0, arg1) {
            arg0.postMessage(arg1);
        }, arguments) };
        imports.wbg.__wbg_postMessage_83a8d58d3fcb6c13 = function() { return handleError(function (arg0, arg1) {
            arg0.postMessage(arg1);
        }, arguments) };
        imports.wbg.__wbg_process_5c1d670bc53614b8 = function(arg0) {
            const ret = arg0.process;
            return ret;
        };
        imports.wbg.__wbg_push_737cfc8c1432c2c6 = function(arg0, arg1) {
            const ret = arg0.push(arg1);
            return ret;
        };
        imports.wbg.__wbg_randomFillSync_ab2cfe79ebbf2740 = function() { return handleError(function (arg0, arg1) {
            arg0.randomFillSync(arg1);
        }, arguments) };
        imports.wbg.__wbg_require_79b1e9274cde3c87 = function() { return handleError(function () {
            const ret = module.require;
            return ret;
        }, arguments) };
        imports.wbg.__wbg_set_65595bdd868b3009 = function(arg0, arg1, arg2) {
            arg0.set(arg1, arg2 >>> 0);
        };
        imports.wbg.__wbg_set_bb8cecf6a62b9f46 = function() { return handleError(function (arg0, arg1, arg2) {
            const ret = Reflect.set(arg0, arg1, arg2);
            return ret;
        }, arguments) };
        imports.wbg.__wbg_setonerror_57eeef5feb01fe7a = function(arg0, arg1) {
            arg0.onerror = arg1;
        };
        imports.wbg.__wbg_setonmessage_5a885b16bdc6dca6 = function(arg0, arg1) {
            arg0.onmessage = arg1;
        };
        imports.wbg.__wbg_settype_39ed370d3edd403c = function(arg0, arg1, arg2) {
            arg0.type = getStringFromWasm0(arg1, arg2);
        };
        imports.wbg.__wbg_stack_0ed75d68575b0f3c = function(arg0, arg1) {
            const ret = arg1.stack;
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        };
        imports.wbg.__wbg_static_accessor_GLOBAL_88a902d13a557d07 = function() {
            const ret = typeof global === 'undefined' ? null : global;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        };
        imports.wbg.__wbg_static_accessor_GLOBAL_THIS_56578be7e9f832b0 = function() {
            const ret = typeof globalThis === 'undefined' ? null : globalThis;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        };
        imports.wbg.__wbg_static_accessor_SELF_37c5d418e4bf5819 = function() {
            const ret = typeof self === 'undefined' ? null : self;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        };
        imports.wbg.__wbg_static_accessor_WINDOW_5de37043a91a9c40 = function() {
            const ret = typeof window === 'undefined' ? null : window;
            return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
        };
        imports.wbg.__wbg_subarray_aa9065fa9dc5df96 = function(arg0, arg1, arg2) {
            const ret = arg0.subarray(arg1 >>> 0, arg2 >>> 0);
            return ret;
        };
        imports.wbg.__wbg_versions_c71aa1626a93e0a1 = function(arg0) {
            const ret = arg0.versions;
            return ret;
        };
        imports.wbg.__wbindgen_bigint_from_u64 = function(arg0) {
            const ret = BigInt.asUintN(64, arg0);
            return ret;
        };
        imports.wbg.__wbindgen_bigint_get_as_i64 = function(arg0, arg1) {
            const v = arg1;
            const ret = typeof(v) === 'bigint' ? v : undefined;
            getDataViewMemory0().setBigInt64(arg0 + 8 * 1, isLikeNone(ret) ? BigInt(0) : ret, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, !isLikeNone(ret), true);
        };
        imports.wbg.__wbindgen_cb_drop = function(arg0) {
            const obj = arg0.original;
            if (obj.cnt-- == 1) {
                obj.a = 0;
                return true;
            }
            const ret = false;
            return ret;
        };
        imports.wbg.__wbindgen_closure_wrapper1731 = function(arg0, arg1, arg2) {
            const ret = makeMutClosure(arg0, arg1, 583, __wbg_adapter_40);
            return ret;
        };
        imports.wbg.__wbindgen_debug_string = function(arg0, arg1) {
            const ret = debugString(arg1);
            const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            const len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        };
        imports.wbg.__wbindgen_init_externref_table = function() {
            const table = wasm.__wbindgen_export_2;
            const offset = table.grow(4);
            table.set(0, undefined);
            table.set(offset + 0, undefined);
            table.set(offset + 1, null);
            table.set(offset + 2, true);
            table.set(offset + 3, false);
            ;
        };
        imports.wbg.__wbindgen_is_function = function(arg0) {
            const ret = typeof(arg0) === 'function';
            return ret;
        };
        imports.wbg.__wbindgen_is_object = function(arg0) {
            const val = arg0;
            const ret = typeof(val) === 'object' && val !== null;
            return ret;
        };
        imports.wbg.__wbindgen_is_string = function(arg0) {
            const ret = typeof(arg0) === 'string';
            return ret;
        };
        imports.wbg.__wbindgen_is_undefined = function(arg0) {
            const ret = arg0 === undefined;
            return ret;
        };
        imports.wbg.__wbindgen_jsval_eq = function(arg0, arg1) {
            const ret = arg0 === arg1;
            return ret;
        };
        imports.wbg.__wbindgen_memory = function() {
            const ret = wasm.memory;
            return ret;
        };
        imports.wbg.__wbindgen_module = function() {
            const ret = __wbg_init.__wbindgen_wasm_module;
            return ret;
        };
        imports.wbg.__wbindgen_number_get = function(arg0, arg1) {
            const obj = arg1;
            const ret = typeof(obj) === 'number' ? obj : undefined;
            getDataViewMemory0().setFloat64(arg0 + 8 * 1, isLikeNone(ret) ? 0 : ret, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, !isLikeNone(ret), true);
        };
        imports.wbg.__wbindgen_number_new = function(arg0) {
            const ret = arg0;
            return ret;
        };
        imports.wbg.__wbindgen_string_get = function(arg0, arg1) {
            const obj = arg1;
            const ret = typeof(obj) === 'string' ? obj : undefined;
            var ptr1 = isLikeNone(ret) ? 0 : passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            var len1 = WASM_VECTOR_LEN;
            getDataViewMemory0().setInt32(arg0 + 4 * 1, len1, true);
            getDataViewMemory0().setInt32(arg0 + 4 * 0, ptr1, true);
        };
        imports.wbg.__wbindgen_string_new = function(arg0, arg1) {
            const ret = getStringFromWasm0(arg0, arg1);
            return ret;
        };
        imports.wbg.__wbindgen_throw = function(arg0, arg1) {
            throw new Error(getStringFromWasm0(arg0, arg1));
        };

        return imports;
    }

    function __wbg_init_memory(imports, memory) {

    }

    function __wbg_finalize_init(instance, module) {
        wasm = instance.exports;
        __wbg_init.__wbindgen_wasm_module = module;
        cachedDataViewMemory0 = null;
        cachedUint8ArrayMemory0 = null;


        wasm.__wbindgen_start();
        return wasm;
    }

    function initSync(module) {
        if (wasm !== undefined) return wasm;


        if (typeof module !== 'undefined') {
            if (Object.getPrototypeOf(module) === Object.prototype) {
                ({module} = module)
            } else {
                console.warn('using deprecated parameters for `initSync()`; pass a single object instead')
            }
        }

        const imports = __wbg_get_imports();

        __wbg_init_memory(imports);

        if (!(module instanceof WebAssembly.Module)) {
            module = new WebAssembly.Module(module);
        }

        const instance = new WebAssembly.Instance(module, imports);

        return __wbg_finalize_init(instance, module);
    }

    async function __wbg_init(module_or_path) {
        if (wasm !== undefined) return wasm;


        if (typeof module_or_path !== 'undefined') {
            if (Object.getPrototypeOf(module_or_path) === Object.prototype) {
                ({module_or_path} = module_or_path)
            } else {
                console.warn('using deprecated parameters for the initialization function; pass a single object instead')
            }
        }

        if (typeof module_or_path === 'undefined' && typeof script_src !== 'undefined') {
            module_or_path = script_src.replace(/\.js$/, '_bg.wasm');
        }
        const imports = __wbg_get_imports();

        if (typeof module_or_path === 'string' || (typeof Request === 'function' && module_or_path instanceof Request) || (typeof URL === 'function' && module_or_path instanceof URL)) {
            module_or_path = fetch(module_or_path);
        }

        __wbg_init_memory(imports);

        const { instance, module } = await __wbg_load(await module_or_path, imports);

        return __wbg_finalize_init(instance, module);
    }

    wasm_bindgen = Object.assign(__wbg_init, { initSync }, __exports);

})();
