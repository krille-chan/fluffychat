let wasm_bindgen = (function(exports) {
    let script_src;
    if (typeof document !== 'undefined' && document.currentScript !== null) {
        script_src = new URL(document.currentScript.src, location.href).toString();
    }

    class WorkerPool {
        static __wrap(ptr) {
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
         * @param {string | null} [wasm_bindgen_name]
         * @returns {WorkerPool}
         */
        static new(initial, script_src, worker_js_preamble, wasm_bindgen_name) {
            const val4 = +(isLikeNone(initial) ? Number.MAX_SAFE_INTEGER : (initial) >>> 0);
            let ptr0, len0, ptr1, len1, ptr2, len2;
            try {
                ptr0 = isLikeNone(script_src) ? 0 : passStringToWasm0(script_src, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                len0 = WASM_VECTOR_LEN;
                ptr1 = isLikeNone(worker_js_preamble) ? 0 : passStringToWasm0(worker_js_preamble, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                len1 = WASM_VECTOR_LEN;
                ptr2 = isLikeNone(wasm_bindgen_name) ? 0 : passStringToWasm0(wasm_bindgen_name, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                len2 = WASM_VECTOR_LEN;
            } catch (e) {
                if (ptr2) { wasm.__wbindgen_free(ptr2, len2 * 1, 1); }
                if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
                if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
                throw e;
            }
            const ret = wasm.workerpool_new(val4, ptr0, len0, ptr1, len1, ptr2, len2);
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
         * @param {string} wasm_bindgen_name
         */
        constructor(initial, script_src, worker_js_preamble, wasm_bindgen_name) {
            const val4 = +initial;
            let ptr0, len0, ptr1, len1, ptr2, len2;
            try {
                ptr0 = passStringToWasm0(script_src, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                len0 = WASM_VECTOR_LEN;
                ptr1 = passStringToWasm0(worker_js_preamble, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                len1 = WASM_VECTOR_LEN;
                ptr2 = passStringToWasm0(wasm_bindgen_name, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                len2 = WASM_VECTOR_LEN;
            } catch (e) {
                if (ptr2) { wasm.__wbindgen_free(ptr2, len2 * 1, 1); }
                if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
                if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
                throw e;
            }
            const ret = wasm.workerpool_new_raw(val4, ptr0, len0, ptr1, len1, ptr2, len2);
            if (ret[2]) {
                throw takeFromExternrefTable0(ret[1]);
            }
            this.__wbg_ptr = ret[0];
            WorkerPoolFinalization.register(this, this.__wbg_ptr, this);
            return this;
        }
    }
    if (Symbol.dispose) WorkerPool.prototype[Symbol.dispose] = WorkerPool.prototype.free;
    exports.WorkerPool = WorkerPool;

    /**
     * @param {number} call_id
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     */
    function frb_dart_fn_deliver_output(call_id, ptr_, rust_vec_len_, data_len_) {
        wasm.frb_dart_fn_deliver_output(call_id, ptr_, rust_vec_len_, data_len_);
    }
    exports.frb_dart_fn_deliver_output = frb_dart_fn_deliver_output;

    /**
     * # Safety
     *
     * This should never be called manually.
     * @param {any} handle
     * @param {any} dart_handler_port
     * @returns {number}
     */
    function frb_dart_opaque_dart2rust_encode(handle, dart_handler_port) {
        const ret = wasm.frb_dart_opaque_dart2rust_encode(handle, dart_handler_port);
        return ret >>> 0;
    }
    exports.frb_dart_opaque_dart2rust_encode = frb_dart_opaque_dart2rust_encode;

    /**
     * @param {number} ptr
     */
    function frb_dart_opaque_drop_thread_box_persistent_handle(ptr) {
        wasm.frb_dart_opaque_drop_thread_box_persistent_handle(ptr);
    }
    exports.frb_dart_opaque_drop_thread_box_persistent_handle = frb_dart_opaque_drop_thread_box_persistent_handle;

    /**
     * @param {number} ptr
     * @returns {any}
     */
    function frb_dart_opaque_rust2dart_decode(ptr) {
        const ret = wasm.frb_dart_opaque_rust2dart_decode(ptr);
        return ret;
    }
    exports.frb_dart_opaque_rust2dart_decode = frb_dart_opaque_rust2dart_decode;

    /**
     * @returns {number}
     */
    function frb_get_rust_content_hash() {
        const ret = wasm.frb_get_rust_content_hash();
        return ret;
    }
    exports.frb_get_rust_content_hash = frb_get_rust_content_hash;

    /**
     * @param {number} func_id
     * @param {any} port_
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     */
    function frb_pde_ffi_dispatcher_primary(func_id, port_, ptr_, rust_vec_len_, data_len_) {
        wasm.frb_pde_ffi_dispatcher_primary(func_id, port_, ptr_, rust_vec_len_, data_len_);
    }
    exports.frb_pde_ffi_dispatcher_primary = frb_pde_ffi_dispatcher_primary;

    /**
     * @param {number} func_id
     * @param {any} ptr_
     * @param {number} rust_vec_len_
     * @param {number} data_len_
     * @returns {any}
     */
    function frb_pde_ffi_dispatcher_sync(func_id, ptr_, rust_vec_len_, data_len_) {
        const ret = wasm.frb_pde_ffi_dispatcher_sync(func_id, ptr_, rust_vec_len_, data_len_);
        return ret;
    }
    exports.frb_pde_ffi_dispatcher_sync = frb_pde_ffi_dispatcher_sync;

    /**
     * ## Safety
     * This function reclaims a raw pointer created by [`TransferClosure`], and therefore
     * should **only** be used in conjunction with it.
     * Furthermore, the WASM module in the worker must have been initialized with the shared
     * memory from the host JS scope.
     * @param {number} payload
     * @param {any[]} transfer
     */
    function receive_transfer_closure(payload, transfer) {
        const val2 = +payload;
        const ptr0 = passArrayJsValueToWasm0(transfer, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.receive_transfer_closure(val2, ptr0, len0);
        if (ret[1]) {
            throw takeFromExternrefTable0(ret[0]);
        }
    }
    exports.receive_transfer_closure = receive_transfer_closure;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_Curve25519PublicKey(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_Curve25519PublicKey = rust_arc_decrement_strong_count_RustOpaque_Curve25519PublicKey;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_Ed25519PublicKey(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_Ed25519PublicKey(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_Ed25519PublicKey = rust_arc_decrement_strong_count_RustOpaque_Ed25519PublicKey;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_Ed25519Signature(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_Ed25519Signature(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_Ed25519Signature = rust_arc_decrement_strong_count_RustOpaque_Ed25519Signature;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_EstablishedSas(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_EstablishedSas(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_EstablishedSas = rust_arc_decrement_strong_count_RustOpaque_EstablishedSas;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_MegolmSessionConfig(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_MegolmSessionConfig(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_MegolmSessionConfig = rust_arc_decrement_strong_count_RustOpaque_MegolmSessionConfig;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_OlmMessage(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_OlmMessage(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_OlmMessage = rust_arc_decrement_strong_count_RustOpaque_OlmMessage;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_OlmSessionConfig(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_OlmSessionConfig(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_OlmSessionConfig = rust_arc_decrement_strong_count_RustOpaque_OlmSessionConfig;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_PkDecryption(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_PkDecryption(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_PkDecryption = rust_arc_decrement_strong_count_RustOpaque_PkDecryption;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_PkEncryption(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_PkEncryption(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_PkEncryption = rust_arc_decrement_strong_count_RustOpaque_PkEncryption;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_RwLockGroupSession(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_RwLockGroupSession(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_RwLockGroupSession = rust_arc_decrement_strong_count_RustOpaque_RwLockGroupSession;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_RwLockInboundGroupSession(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_RwLockInboundGroupSession(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_RwLockInboundGroupSession = rust_arc_decrement_strong_count_RustOpaque_RwLockInboundGroupSession;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_RwLockSession(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_RwLockSession(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_RwLockSession = rust_arc_decrement_strong_count_RustOpaque_RwLockSession;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning = rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas = rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas;

    /**
     * @param {number} ptr
     */
    function rust_arc_decrement_strong_count_RustOpaque_stdsyncRwLockAccount(ptr) {
        wasm.rust_arc_decrement_strong_count_RustOpaque_stdsyncRwLockAccount(ptr);
    }
    exports.rust_arc_decrement_strong_count_RustOpaque_stdsyncRwLockAccount = rust_arc_decrement_strong_count_RustOpaque_stdsyncRwLockAccount;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey = rust_arc_increment_strong_count_RustOpaque_Curve25519PublicKey;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_Ed25519PublicKey(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Ed25519PublicKey(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_Ed25519PublicKey = rust_arc_increment_strong_count_RustOpaque_Ed25519PublicKey;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_Ed25519Signature(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_Ed25519Signature(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_Ed25519Signature = rust_arc_increment_strong_count_RustOpaque_Ed25519Signature;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_EstablishedSas(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_EstablishedSas(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_EstablishedSas = rust_arc_increment_strong_count_RustOpaque_EstablishedSas;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_MegolmSessionConfig(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_MegolmSessionConfig(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_MegolmSessionConfig = rust_arc_increment_strong_count_RustOpaque_MegolmSessionConfig;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_OlmMessage(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_OlmMessage(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_OlmMessage = rust_arc_increment_strong_count_RustOpaque_OlmMessage;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_OlmSessionConfig(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_OlmSessionConfig(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_OlmSessionConfig = rust_arc_increment_strong_count_RustOpaque_OlmSessionConfig;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_PkDecryption(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_PkDecryption(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_PkDecryption = rust_arc_increment_strong_count_RustOpaque_PkDecryption;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_PkEncryption(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_PkEncryption(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_PkEncryption = rust_arc_increment_strong_count_RustOpaque_PkEncryption;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_RwLockGroupSession(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_RwLockGroupSession(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_RwLockGroupSession = rust_arc_increment_strong_count_RustOpaque_RwLockGroupSession;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_RwLockInboundGroupSession(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_RwLockInboundGroupSession(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_RwLockInboundGroupSession = rust_arc_increment_strong_count_RustOpaque_RwLockInboundGroupSession;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_RwLockSession(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_RwLockSession(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_RwLockSession = rust_arc_increment_strong_count_RustOpaque_RwLockSession;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning = rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPkSigning;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas = rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerVodozemacSas;

    /**
     * @param {number} ptr
     */
    function rust_arc_increment_strong_count_RustOpaque_stdsyncRwLockAccount(ptr) {
        wasm.rust_arc_increment_strong_count_RustOpaque_stdsyncRwLockAccount(ptr);
    }
    exports.rust_arc_increment_strong_count_RustOpaque_stdsyncRwLockAccount = rust_arc_increment_strong_count_RustOpaque_stdsyncRwLockAccount;

    function wasm_start_callback() {
        wasm.wasm_start_callback();
    }
    exports.wasm_start_callback = wasm_start_callback;

    /**
     * @param {string} key
     * @returns {any}
     */
    function wire__crate__bindings__PkSigning_from_secret_key(key) {
        const ptr0 = passStringToWasm0(key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__PkSigning_from_secret_key(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__PkSigning_from_secret_key = wire__crate__bindings__PkSigning_from_secret_key;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__PkSigning_new() {
        const ret = wasm.wire__crate__bindings__PkSigning_new();
        return ret;
    }
    exports.wire__crate__bindings__PkSigning_new = wire__crate__bindings__PkSigning_new;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__PkSigning_public_key(that) {
        const ret = wasm.wire__crate__bindings__PkSigning_public_key(that);
        return ret;
    }
    exports.wire__crate__bindings__PkSigning_public_key = wire__crate__bindings__PkSigning_public_key;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__PkSigning_secret_key(that) {
        const ret = wasm.wire__crate__bindings__PkSigning_secret_key(that);
        return ret;
    }
    exports.wire__crate__bindings__PkSigning_secret_key = wire__crate__bindings__PkSigning_secret_key;

    /**
     * @param {any} that
     * @param {string} message
     * @returns {any}
     */
    function wire__crate__bindings__PkSigning_sign(that, message) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__PkSigning_sign(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__PkSigning_sign = wire__crate__bindings__PkSigning_sign;

    /**
     * @param {any} that
     * @param {string} other_public_key
     * @returns {any}
     */
    function wire__crate__bindings__VodozemacSas_establish_sas_secret(that, other_public_key) {
        const ptr0 = passStringToWasm0(other_public_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__VodozemacSas_establish_sas_secret(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__VodozemacSas_establish_sas_secret = wire__crate__bindings__VodozemacSas_establish_sas_secret;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__VodozemacSas_new() {
        const ret = wasm.wire__crate__bindings__VodozemacSas_new();
        return ret;
    }
    exports.wire__crate__bindings__VodozemacSas_new = wire__crate__bindings__VodozemacSas_new;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__VodozemacSas_public_key(that) {
        const ret = wasm.wire__crate__bindings__VodozemacSas_public_key(that);
        return ret;
    }
    exports.wire__crate__bindings__VodozemacSas_public_key = wire__crate__bindings__VodozemacSas_public_key;

    /**
     * @param {Uint8Array | number[]} input
     * @param {Uint8Array | number[]} key
     * @param {Uint8Array | number[]} iv
     * @returns {any}
     */
    function wire__crate__bindings__aes_ctr(input, key, iv) {
        let ptr0, len0, ptr1, len1, ptr2, len2;
        try {
            ptr0 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
            ptr2 = passArray8ToWasm0(iv, wasm.__wbindgen_malloc);
            len2 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr2) { wasm.__wbindgen_free(ptr2, len2 * 1, 1); }
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__aes_ctr(ptr0, len0, ptr1, len1, ptr2, len2);
        return ret;
    }
    exports.wire__crate__bindings__aes_ctr = wire__crate__bindings__aes_ctr;

    /**
     * @param {Uint8Array | number[]} key
     * @param {Uint8Array | number[]} input
     * @returns {any}
     */
    function wire__crate__bindings__hmac(key, input) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passArray8ToWasm0(key, wasm.__wbindgen_malloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__hmac(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__hmac = wire__crate__bindings__hmac;

    /**
     * @param {Uint8Array | number[]} passphrase
     * @param {Uint8Array | number[]} salt
     * @param {number} iterations
     * @returns {any}
     */
    function wire__crate__bindings__pbkdf2(passphrase, salt, iterations) {
        const val3 = +iterations;
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passArray8ToWasm0(passphrase, wasm.__wbindgen_malloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(salt, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__pbkdf2(ptr0, len0, ptr1, len1, val3);
        return ret;
    }
    exports.wire__crate__bindings__pbkdf2 = wire__crate__bindings__pbkdf2;

    /**
     * @param {Uint8Array | number[]} input
     * @returns {any}
     */
    function wire__crate__bindings__sha256(input) {
        const ptr0 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__sha256(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__sha256 = wire__crate__bindings__sha256;

    /**
     * @param {Uint8Array | number[]} input
     * @returns {any}
     */
    function wire__crate__bindings__sha512(input) {
        const ptr0 = passArray8ToWasm0(input, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__sha512(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__sha512 = wire__crate__bindings__sha512;

    /**
     * @param {any} that
     * @param {any} config
     * @param {any} their_identity_key
     * @param {string} pre_key_message_base64
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_create_inbound_session(that, config, their_identity_key, pre_key_message_base64) {
        const ptr0 = passStringToWasm0(pre_key_message_base64, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_create_inbound_session(that, config, their_identity_key, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_create_inbound_session = wire__crate__bindings__vodozemac_account_create_inbound_session;

    /**
     * @param {any} that
     * @param {any} config
     * @param {any} identity_key
     * @param {any} one_time_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_create_outbound_session(that, config, identity_key, one_time_key) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_create_outbound_session(that, config, identity_key, one_time_key);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_create_outbound_session = wire__crate__bindings__vodozemac_account_create_outbound_session;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_curve25519_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_curve25519_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_curve25519_key = wire__crate__bindings__vodozemac_account_curve25519_key;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_ed25519_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_ed25519_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_ed25519_key = wire__crate__bindings__vodozemac_account_ed25519_key;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_fallback_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_fallback_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_fallback_key = wire__crate__bindings__vodozemac_account_fallback_key;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_forget_fallback_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_forget_fallback_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_forget_fallback_key = wire__crate__bindings__vodozemac_account_forget_fallback_key;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_from_olm_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_account_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_from_olm_pickle_encrypted = wire__crate__bindings__vodozemac_account_from_olm_pickle_encrypted;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_from_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_account_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_from_pickle_encrypted = wire__crate__bindings__vodozemac_account_from_pickle_encrypted;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_generate_fallback_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_generate_fallback_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_generate_fallback_key = wire__crate__bindings__vodozemac_account_generate_fallback_key;

    /**
     * @param {any} that
     * @param {any} count
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_generate_one_time_keys(that, count) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_generate_one_time_keys(that, count);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_generate_one_time_keys = wire__crate__bindings__vodozemac_account_generate_one_time_keys;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_identity_keys(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_identity_keys(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_identity_keys = wire__crate__bindings__vodozemac_account_identity_keys;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_mark_keys_as_published(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_mark_keys_as_published(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_mark_keys_as_published = wire__crate__bindings__vodozemac_account_mark_keys_as_published;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_max_number_of_one_time_keys(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_max_number_of_one_time_keys(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_max_number_of_one_time_keys = wire__crate__bindings__vodozemac_account_max_number_of_one_time_keys;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_new() {
        const ret = wasm.wire__crate__bindings__vodozemac_account_new();
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_new = wire__crate__bindings__vodozemac_account_new;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_one_time_keys(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_account_one_time_keys(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_one_time_keys = wire__crate__bindings__vodozemac_account_one_time_keys;

    /**
     * @param {any} that
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_pickle_encrypted(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_pickle_encrypted(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_pickle_encrypted = wire__crate__bindings__vodozemac_account_pickle_encrypted;

    /**
     * @param {any} that
     * @param {string} public_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_remove_one_time_key(that, public_key) {
        const ptr0 = passStringToWasm0(public_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_remove_one_time_key(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_remove_one_time_key = wire__crate__bindings__vodozemac_account_remove_one_time_key;

    /**
     * @param {any} that
     * @param {string} message
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_account_sign(that, message) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_account_sign(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_account_sign = wire__crate__bindings__vodozemac_account_sign;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_curve_25519_public_key_as_bytes(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_as_bytes(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_curve_25519_public_key_as_bytes = wire__crate__bindings__vodozemac_curve_25519_public_key_as_bytes;

    /**
     * @param {string} base64_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_curve_25519_public_key_from_base64(base64_key) {
        const ptr0 = passStringToWasm0(base64_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_from_base64(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_curve_25519_public_key_from_base64 = wire__crate__bindings__vodozemac_curve_25519_public_key_from_base64;

    /**
     * @param {Uint8Array | number[]} bytes
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_curve_25519_public_key_from_slice(bytes) {
        const ptr0 = passArray8ToWasm0(bytes, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_from_slice(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_curve_25519_public_key_from_slice = wire__crate__bindings__vodozemac_curve_25519_public_key_from_slice;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_curve_25519_public_key_to_base64(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_curve_25519_public_key_to_base64(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_curve_25519_public_key_to_base64 = wire__crate__bindings__vodozemac_curve_25519_public_key_to_base64;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_public_key_as_bytes(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_as_bytes(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_public_key_as_bytes = wire__crate__bindings__vodozemac_ed_25519_public_key_as_bytes;

    /**
     * @param {string} base64_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_public_key_from_base64(base64_key) {
        const ptr0 = passStringToWasm0(base64_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_from_base64(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_public_key_from_base64 = wire__crate__bindings__vodozemac_ed_25519_public_key_from_base64;

    /**
     * @param {Uint8Array | number[]} bytes
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_public_key_from_slice(bytes) {
        const ptr0 = passArray8ToWasm0(bytes, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_from_slice(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_public_key_from_slice = wire__crate__bindings__vodozemac_ed_25519_public_key_from_slice;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_public_key_to_base64(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_to_base64(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_public_key_to_base64 = wire__crate__bindings__vodozemac_ed_25519_public_key_to_base64;

    /**
     * @param {any} that
     * @param {string} message
     * @param {any} signature
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_public_key_verify(that, message, signature) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_public_key_verify(that, ptr0, len0, signature);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_public_key_verify = wire__crate__bindings__vodozemac_ed_25519_public_key_verify;

    /**
     * @param {string} signature
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_signature_from_base64(signature) {
        const ptr0 = passStringToWasm0(signature, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_from_base64(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_signature_from_base64 = wire__crate__bindings__vodozemac_ed_25519_signature_from_base64;

    /**
     * @param {Uint8Array | number[]} bytes
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_signature_from_slice(bytes) {
        const ptr0 = passArray8ToWasm0(bytes, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_from_slice(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_signature_from_slice = wire__crate__bindings__vodozemac_ed_25519_signature_from_slice;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_signature_to_base64(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_to_base64(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_signature_to_base64 = wire__crate__bindings__vodozemac_ed_25519_signature_to_base64;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_ed_25519_signature_to_bytes(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_ed_25519_signature_to_bytes(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_ed_25519_signature_to_bytes = wire__crate__bindings__vodozemac_ed_25519_signature_to_bytes;

    /**
     * @param {any} that
     * @param {string} input
     * @param {string} info
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_established_sas_calculate_mac(that, input, info) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(input, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_calculate_mac(that, ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_established_sas_calculate_mac = wire__crate__bindings__vodozemac_established_sas_calculate_mac;

    /**
     * @param {any} that
     * @param {string} input
     * @param {string} info
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_established_sas_calculate_mac_deprecated(that, input, info) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(input, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_calculate_mac_deprecated(that, ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_established_sas_calculate_mac_deprecated = wire__crate__bindings__vodozemac_established_sas_calculate_mac_deprecated;

    /**
     * @param {any} that
     * @param {string} info
     * @param {number} length
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_established_sas_generate_bytes(that, info, length) {
        const val2 = +length;
        const ptr0 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_generate_bytes(that, ptr0, len0, val2);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_established_sas_generate_bytes = wire__crate__bindings__vodozemac_established_sas_generate_bytes;

    /**
     * @param {any} that
     * @param {string} input
     * @param {string} info
     * @param {string} mac
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_established_sas_verify_mac(that, input, info, mac) {
        let ptr0, len0, ptr1, len1, ptr2, len2;
        try {
            ptr0 = passStringToWasm0(input, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passStringToWasm0(info, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len1 = WASM_VECTOR_LEN;
            ptr2 = passStringToWasm0(mac, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len2 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr2) { wasm.__wbindgen_free(ptr2, len2 * 1, 1); }
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_established_sas_verify_mac(that, ptr0, len0, ptr1, len1, ptr2, len2);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_established_sas_verify_mac = wire__crate__bindings__vodozemac_established_sas_verify_mac;

    /**
     * @param {any} that
     * @param {string} plaintext
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_encrypt(that, plaintext) {
        const ptr0 = passStringToWasm0(plaintext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_encrypt(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_encrypt = wire__crate__bindings__vodozemac_group_session_encrypt;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_from_olm_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_from_olm_pickle_encrypted = wire__crate__bindings__vodozemac_group_session_from_olm_pickle_encrypted;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_from_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_from_pickle_encrypted = wire__crate__bindings__vodozemac_group_session_from_pickle_encrypted;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_message_index(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_message_index(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_message_index = wire__crate__bindings__vodozemac_group_session_message_index;

    /**
     * @param {any} config
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_new(config) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_new(config);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_new = wire__crate__bindings__vodozemac_group_session_new;

    /**
     * @param {any} that
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_pickle_encrypted(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_pickle_encrypted(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_pickle_encrypted = wire__crate__bindings__vodozemac_group_session_pickle_encrypted;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_session_config(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_session_config(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_session_config = wire__crate__bindings__vodozemac_group_session_session_config;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_session_id(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_session_id(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_session_id = wire__crate__bindings__vodozemac_group_session_session_id;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_session_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_session_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_session_key = wire__crate__bindings__vodozemac_group_session_session_key;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_group_session_to_inbound(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_group_session_to_inbound(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_group_session_to_inbound = wire__crate__bindings__vodozemac_group_session_to_inbound;

    /**
     * @param {any} that
     * @param {string} encrypted
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_decrypt(that, encrypted) {
        const ptr0 = passStringToWasm0(encrypted, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_decrypt(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_decrypt = wire__crate__bindings__vodozemac_inbound_group_session_decrypt;

    /**
     * @param {any} that
     * @param {number} index
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_export_at(that, index) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_export_at(that, index);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_export_at = wire__crate__bindings__vodozemac_inbound_group_session_export_at;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_export_at_first_known_index(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_export_at_first_known_index(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_export_at_first_known_index = wire__crate__bindings__vodozemac_inbound_group_session_export_at_first_known_index;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_first_known_index(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_first_known_index(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_first_known_index = wire__crate__bindings__vodozemac_inbound_group_session_first_known_index;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_from_olm_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_from_olm_pickle_encrypted = wire__crate__bindings__vodozemac_inbound_group_session_from_olm_pickle_encrypted;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_from_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_from_pickle_encrypted = wire__crate__bindings__vodozemac_inbound_group_session_from_pickle_encrypted;

    /**
     * @param {string} exported_session_key
     * @param {any} config
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_import(exported_session_key, config) {
        const ptr0 = passStringToWasm0(exported_session_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_import(ptr0, len0, config);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_import = wire__crate__bindings__vodozemac_inbound_group_session_import;

    /**
     * @param {string} session_key
     * @param {any} config
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_new(session_key, config) {
        const ptr0 = passStringToWasm0(session_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_new(ptr0, len0, config);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_new = wire__crate__bindings__vodozemac_inbound_group_session_new;

    /**
     * @param {any} that
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_pickle_encrypted(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_pickle_encrypted(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_pickle_encrypted = wire__crate__bindings__vodozemac_inbound_group_session_pickle_encrypted;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_inbound_group_session_session_id(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_inbound_group_session_session_id(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_inbound_group_session_session_id = wire__crate__bindings__vodozemac_inbound_group_session_session_id;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_megolm_session_config_version(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_megolm_session_config_version(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_megolm_session_config_version = wire__crate__bindings__vodozemac_megolm_session_config_version;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_megolm_session_config_version_1() {
        const ret = wasm.wire__crate__bindings__vodozemac_megolm_session_config_version_1();
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_megolm_session_config_version_1 = wire__crate__bindings__vodozemac_megolm_session_config_version_1;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_megolm_session_config_version_2() {
        const ret = wasm.wire__crate__bindings__vodozemac_megolm_session_config_version_2();
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_megolm_session_config_version_2 = wire__crate__bindings__vodozemac_megolm_session_config_version_2;

    /**
     * @param {any} message_type
     * @param {string} ciphertext
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_olm_message_from_parts(message_type, ciphertext) {
        const ptr0 = passStringToWasm0(ciphertext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_olm_message_from_parts(message_type, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_olm_message_from_parts = wire__crate__bindings__vodozemac_olm_message_from_parts;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_olm_message_message(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_message_message(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_olm_message_message = wire__crate__bindings__vodozemac_olm_message_message;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_olm_message_message_type(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_message_message_type(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_olm_message_message_type = wire__crate__bindings__vodozemac_olm_message_message_type;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_olm_session_config_version(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_session_config_version(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_olm_session_config_version = wire__crate__bindings__vodozemac_olm_session_config_version;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_olm_session_config_version_1() {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_session_config_version_1();
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_olm_session_config_version_1 = wire__crate__bindings__vodozemac_olm_session_config_version_1;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_olm_session_config_version_2() {
        const ret = wasm.wire__crate__bindings__vodozemac_olm_session_config_version_2();
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_olm_session_config_version_2 = wire__crate__bindings__vodozemac_olm_session_config_version_2;

    /**
     * @param {any} that
     * @param {any} message
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_decryption_decrypt(that, message) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_decrypt(that, message);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_decryption_decrypt = wire__crate__bindings__vodozemac_pk_decryption_decrypt;

    /**
     * @param {Uint8Array | number[]} secret_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_decryption_from_key(secret_key) {
        const ptr0 = passArray8ToWasm0(secret_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_from_key(ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_decryption_from_key = wire__crate__bindings__vodozemac_pk_decryption_from_key;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_decryption_from_libolm_pickle(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_from_libolm_pickle(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_decryption_from_libolm_pickle = wire__crate__bindings__vodozemac_pk_decryption_from_libolm_pickle;

    /**
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_decryption_new() {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_new();
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_decryption_new = wire__crate__bindings__vodozemac_pk_decryption_new;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_decryption_private_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_private_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_decryption_private_key = wire__crate__bindings__vodozemac_pk_decryption_private_key;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_decryption_public_key(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_public_key(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_decryption_public_key = wire__crate__bindings__vodozemac_pk_decryption_public_key;

    /**
     * @param {any} that
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_decryption_to_libolm_pickle(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_decryption_to_libolm_pickle(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_decryption_to_libolm_pickle = wire__crate__bindings__vodozemac_pk_decryption_to_libolm_pickle;

    /**
     * @param {any} that
     * @param {string} message
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_encryption_encrypt(that, message) {
        const ptr0 = passStringToWasm0(message, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_pk_encryption_encrypt(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_encryption_encrypt = wire__crate__bindings__vodozemac_pk_encryption_encrypt;

    /**
     * @param {any} public_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_encryption_from_key(public_key) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_encryption_from_key(public_key);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_encryption_from_key = wire__crate__bindings__vodozemac_pk_encryption_from_key;

    /**
     * @param {string} ciphertext
     * @param {string} mac
     * @param {string} ephemeral_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_message_from_base64(ciphertext, mac, ephemeral_key) {
        let ptr0, len0, ptr1, len1, ptr2, len2;
        try {
            ptr0 = passStringToWasm0(ciphertext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passStringToWasm0(mac, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len1 = WASM_VECTOR_LEN;
            ptr2 = passStringToWasm0(ephemeral_key, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len2 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr2) { wasm.__wbindgen_free(ptr2, len2 * 1, 1); }
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_pk_message_from_base64(ptr0, len0, ptr1, len1, ptr2, len2);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_message_from_base64 = wire__crate__bindings__vodozemac_pk_message_from_base64;

    /**
     * @param {Uint8Array | number[]} ciphertext
     * @param {Uint8Array | number[]} mac
     * @param {any} ephemeral_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_message_new(ciphertext, mac, ephemeral_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passArray8ToWasm0(ciphertext, wasm.__wbindgen_malloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(mac, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_pk_message_new(ptr0, len0, ptr1, len1, ephemeral_key);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_message_new = wire__crate__bindings__vodozemac_pk_message_new;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_pk_message_to_base64(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_pk_message_to_base64(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_pk_message_to_base64 = wire__crate__bindings__vodozemac_pk_message_to_base64;

    /**
     * @param {any} that
     * @param {any} message
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_decrypt(that, message) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_decrypt(that, message);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_decrypt = wire__crate__bindings__vodozemac_session_decrypt;

    /**
     * @param {any} that
     * @param {string} plaintext
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_encrypt(that, plaintext) {
        const ptr0 = passStringToWasm0(plaintext, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_session_encrypt(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_encrypt = wire__crate__bindings__vodozemac_session_encrypt;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_from_olm_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_session_from_olm_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_from_olm_pickle_encrypted = wire__crate__bindings__vodozemac_session_from_olm_pickle_encrypted;

    /**
     * @param {string} pickle
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_from_pickle_encrypted(pickle, pickle_key) {
        let ptr0, len0, ptr1, len1;
        try {
            ptr0 = passStringToWasm0(pickle, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
            len0 = WASM_VECTOR_LEN;
            ptr1 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
            len1 = WASM_VECTOR_LEN;
        } catch (e) {
            if (ptr1) { wasm.__wbindgen_free(ptr1, len1 * 1, 1); }
            if (ptr0) { wasm.__wbindgen_free(ptr0, len0 * 1, 1); }
            throw e;
        }
        const ret = wasm.wire__crate__bindings__vodozemac_session_from_pickle_encrypted(ptr0, len0, ptr1, len1);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_from_pickle_encrypted = wire__crate__bindings__vodozemac_session_from_pickle_encrypted;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_has_received_message(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_has_received_message(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_has_received_message = wire__crate__bindings__vodozemac_session_has_received_message;

    /**
     * @param {any} that
     * @param {Uint8Array | number[]} pickle_key
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_pickle_encrypted(that, pickle_key) {
        const ptr0 = passArray8ToWasm0(pickle_key, wasm.__wbindgen_malloc);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.wire__crate__bindings__vodozemac_session_pickle_encrypted(that, ptr0, len0);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_pickle_encrypted = wire__crate__bindings__vodozemac_session_pickle_encrypted;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_session_config(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_session_config(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_session_config = wire__crate__bindings__vodozemac_session_session_config;

    /**
     * @param {any} that
     * @returns {any}
     */
    function wire__crate__bindings__vodozemac_session_session_id(that) {
        const ret = wasm.wire__crate__bindings__vodozemac_session_session_id(that);
        return ret;
    }
    exports.wire__crate__bindings__vodozemac_session_session_id = wire__crate__bindings__vodozemac_session_session_id;
    function __wbg_get_imports(memory) {
        const import0 = {
            __proto__: null,
            __wbg___wbindgen_bigint_get_as_i64_11da4b52cd0aedef: function(arg0, arg1) {
                const v = arg1;
                const ret = typeof(v) === 'bigint' ? v : undefined;
                getDataViewMemory0().setBigInt64((arg0 >>> 0) + 8 * 1, isLikeNone(ret) ? BigInt(0) : ret, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, !isLikeNone(ret), true);
            },
            __wbg___wbindgen_debug_string_f249a2a76caa9a55: function(arg0, arg1) {
                const ret = debugString(arg1);
                const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                const len1 = WASM_VECTOR_LEN;
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 1, len1, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, ptr1, true);
            },
            __wbg___wbindgen_is_undefined_be5b34249ff1fc15: function(arg0) {
                const ret = arg0 === undefined;
                return ret;
            },
            __wbg___wbindgen_jsval_eq_38d7bfbe4cc84039: function(arg0, arg1) {
                const ret = arg0 === arg1;
                return ret;
            },
            __wbg___wbindgen_memory_17a1178bc3328ea3: function() {
                const ret = wasm.memory;
                return ret;
            },
            __wbg___wbindgen_module_2e98e71e8e96b4ac: function() {
                const ret = wasmModule;
                return ret;
            },
            __wbg___wbindgen_number_get_934b640d0889af78: function(arg0, arg1) {
                const obj = arg1;
                const ret = typeof(obj) === 'number' ? obj : undefined;
                getDataViewMemory0().setFloat64((arg0 >>> 0) + 8 * 1, isLikeNone(ret) ? 0 : ret, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, !isLikeNone(ret), true);
            },
            __wbg___wbindgen_string_get_7ce8eee7fd327545: function(arg0, arg1) {
                const obj = arg1;
                const ret = typeof(obj) === 'string' ? obj : undefined;
                var ptr1 = isLikeNone(ret) ? 0 : passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                var len1 = WASM_VECTOR_LEN;
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 1, len1, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, ptr1, true);
            },
            __wbg___wbindgen_throw_4c88d8bf264fd984: function(arg0, arg1) {
                throw new Error(getStringFromWasm0(arg0, arg1));
            },
            __wbg__wbg_cb_unref_09736879a3f67559: function(arg0) {
                arg0._wbg_cb_unref();
            },
            __wbg_close_5cce31cdca29905f: function() { return handleError(function (arg0) {
                arg0.close();
            }, arguments); },
            __wbg_createObjectURL_45693a1454d24dac: function() { return handleError(function (arg0, arg1) {
                const ret = URL.createObjectURL(arg1);
                const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                const len1 = WASM_VECTOR_LEN;
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 1, len1, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, ptr1, true);
            }, arguments); },
            __wbg_data_c7e5e8500f1bca2f: function(arg0) {
                const ret = arg0.data;
                return ret;
            },
            __wbg_error_757e9472f8410341: function(arg0, arg1) {
                let deferred0_0;
                let deferred0_1;
                try {
                    deferred0_0 = arg0;
                    deferred0_1 = arg1;
                    console.error(getStringFromWasm0(arg0, arg1));
                } finally {
                    wasm.__wbindgen_free(deferred0_0, deferred0_1, 1);
                }
            },
            __wbg_error_7d496c22586cebef: function(arg0, arg1) {
                console.error(getStringFromWasm0(arg0, arg1));
            },
            __wbg_eval_4b86caa0c9fd0a9c: function() { return handleError(function (arg0, arg1) {
                const ret = eval(getStringFromWasm0(arg0, arg1));
                return ret;
            }, arguments); },
            __wbg_getRandomValues_db3aaeb8394c1d98: function() { return handleError(function (arg0) {
                globalThis.crypto.getRandomValues(arg0);
            }, arguments); },
            __wbg_get_2080c49015e35254: function() { return handleError(function (arg0, arg1) {
                const ret = Reflect.get(arg0, arg1);
                return ret;
            }, arguments); },
            __wbg_get_d7176cfb76d71114: function(arg0, arg1) {
                const ret = arg0[arg1 >>> 0];
                return ret;
            },
            __wbg_instanceof_BroadcastChannel_4c193d7ae500a039: function(arg0) {
                let result;
                try {
                    result = arg0 instanceof BroadcastChannel;
                } catch (_) {
                    result = false;
                }
                const ret = result;
                return ret;
            },
            __wbg_instanceof_DedicatedWorkerGlobalScope_3f1bee35601e7e7b: function(arg0) {
                let result;
                try {
                    result = arg0 instanceof DedicatedWorkerGlobalScope;
                } catch (_) {
                    result = false;
                }
                const ret = result;
                return ret;
            },
            __wbg_instanceof_ErrorEvent_488845d0efd7d3a7: function(arg0) {
                let result;
                try {
                    result = arg0 instanceof ErrorEvent;
                } catch (_) {
                    result = false;
                }
                const ret = result;
                return ret;
            },
            __wbg_instanceof_MessageEvent_7f71d71db210f737: function(arg0) {
                let result;
                try {
                    result = arg0 instanceof MessageEvent;
                } catch (_) {
                    result = false;
                }
                const ret = result;
                return ret;
            },
            __wbg_isArray_bcf1376d0d732d08: function(arg0) {
                const ret = Array.isArray(arg0);
                return ret;
            },
            __wbg_length_186163212ffe79c3: function(arg0) {
                const ret = arg0.length;
                return ret;
            },
            __wbg_length_b03a0fabb109b1e9: function(arg0) {
                const ret = arg0.length;
                return ret;
            },
            __wbg_message_4f4d0f24ef6c18e6: function(arg0, arg1) {
                const ret = arg1.message;
                const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                const len1 = WASM_VECTOR_LEN;
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 1, len1, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, ptr1, true);
            },
            __wbg_name_a38e11ceedfe3222: function(arg0, arg1) {
                const ret = arg1.name;
                const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                const len1 = WASM_VECTOR_LEN;
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 1, len1, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, ptr1, true);
            },
            __wbg_new_13de428334042d26: function(arg0) {
                const ret = new Uint8Array(arg0);
                return ret;
            },
            __wbg_new_37eb45aaf5eeb820: function() {
                const ret = new Array();
                return ret;
            },
            __wbg_new_b00e30ff1da50918: function() { return handleError(function (arg0, arg1) {
                const ret = new BroadcastChannel(getStringFromWasm0(arg0, arg1));
                return ret;
            }, arguments); },
            __wbg_new_bb74001155cb8ca8: function() {
                const ret = new Error();
                return ret;
            },
            __wbg_new_cd4348290afae586: function() {
                const ret = new Object();
                return ret;
            },
            __wbg_new_df63236ec481fcd7: function() { return handleError(function (arg0, arg1) {
                const ret = new Worker(getStringFromWasm0(arg0, arg1));
                return ret;
            }, arguments); },
            __wbg_new_from_slice_b8daf545a41c6aa0: function(arg0, arg1) {
                const ret = new Uint8Array(getArrayU8FromWasm0(arg0, arg1));
                return ret;
            },
            __wbg_new_with_blob_sequence_and_options_39873c1e60e91f3e: function() { return handleError(function (arg0, arg1) {
                const ret = new Blob(arg0, arg1);
                return ret;
            }, arguments); },
            __wbg_new_with_length_01b143a7e5dd5a3e: function(arg0) {
                const ret = new Uint8Array(arg0 >>> 0);
                return ret;
            },
            __wbg_of_e7ea0fcd535c1444: function(arg0, arg1) {
                const ret = Array.of(arg0, arg1);
                return ret;
            },
            __wbg_postMessage_2ba884e073e237f3: function() { return handleError(function (arg0, arg1) {
                arg0.postMessage(arg1);
            }, arguments); },
            __wbg_postMessage_408dcc1ee376f42d: function() { return handleError(function (arg0, arg1) {
                arg0.postMessage(arg1);
            }, arguments); },
            __wbg_postMessage_61772322081d1756: function() { return handleError(function (arg0, arg1) {
                arg0.postMessage(arg1);
            }, arguments); },
            __wbg_prototypesetcall_13162965d1fe7aa3: function(arg0, arg1, arg2) {
                Uint8Array.prototype.set.call(getArrayU8FromWasm0(arg0, arg1), arg2);
            },
            __wbg_push_c9f4893fc209f768: function(arg0, arg1) {
                const ret = arg0.push(arg1);
                return ret;
            },
            __wbg_set_onerror_8346fd6e80c876c8: function(arg0, arg1) {
                arg0.onerror = arg1;
            },
            __wbg_set_onmessage_fb42c85f5237566a: function(arg0, arg1) {
                arg0.onmessage = arg1;
            },
            __wbg_set_type_609b0cea6429d7bb: function(arg0, arg1, arg2) {
                arg0.type = getStringFromWasm0(arg1, arg2);
            },
            __wbg_stack_575c4e0918581b9c: function(arg0, arg1) {
                const ret = arg1.stack;
                const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
                const len1 = WASM_VECTOR_LEN;
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 1, len1, true);
                getDataViewMemory0().setInt32((arg0 >>> 0) + 4 * 0, ptr1, true);
            },
            __wbg_static_accessor_GLOBAL_THIS_003ee833af9699fc: function() {
                const ret = typeof globalThis === 'undefined' ? undefined : globalThis;
                return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
            },
            __wbg_static_accessor_GLOBAL_e4293fb22cbe77da: function() {
                const ret = typeof global === 'undefined' ? undefined : global;
                return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
            },
            __wbg_static_accessor_SELF_53bb20457401453d: function() {
                const ret = typeof self === 'undefined' ? undefined : self;
                return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
            },
            __wbg_static_accessor_WINDOW_b5e0810bfecb7feb: function() {
                const ret = typeof window === 'undefined' ? undefined : window;
                return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
            },
            __wbg_subarray_58f388a9247ac0bb: function(arg0, arg1, arg2) {
                const ret = arg0.subarray(arg1 >>> 0, arg2 >>> 0);
                return ret;
            },
            __wbindgen_generic_0000000000000001: function(arg0, arg1) {
                // Cast intrinsic for `Closure(Closure { owned: true, function: Function { arguments: [NamedExternref("Event")], shim_idx: 625, ret: Unit, inner_ret: Some(Unit) }, mutable: true }) -> Externref`.
                const ret = makeMutClosure(arg0, arg1, wasm_bindgen_ae17882a171676a1___convert__closures_____invoke___web_sys_4d273f66bafd7a9a___features__gen_MessageEvent__MessageEvent______true_);
                return ret;
            },
            __wbindgen_generic_0000000000000002: function(arg0, arg1) {
                // Cast intrinsic for `Closure(Closure { owned: true, function: Function { arguments: [], shim_idx: 627, ret: Unit, inner_ret: Some(Unit) }, mutable: true }) -> Externref`.
                const ret = makeMutClosure(arg0, arg1, wasm_bindgen_ae17882a171676a1___convert__closures_____invoke_______true_);
                return ret;
            },
            __wbindgen_generic_0000000000000003: function(arg0) {
                // Cast intrinsic for `F64 -> Externref`.
                const ret = arg0;
                return ret;
            },
            __wbindgen_generic_0000000000000004: function(arg0, arg1) {
                // Cast intrinsic for `Ref(String) -> Externref`.
                const ret = getStringFromWasm0(arg0, arg1);
                return ret;
            },
            __wbindgen_generic_0000000000000005: function(arg0) {
                // Cast intrinsic for `U64 -> Externref`.
                const ret = BigInt.asUintN(64, arg0);
                return ret;
            },
            __wbindgen_init_externref_table: function() {
                const table = wasm.__wbindgen_externrefs;
                table.set(0, undefined);
                table.set(1024, undefined);
                table.set(1025, null);
                table.set(1026, true);
                table.set(1027, false);
            },
            memory: memory || new WebAssembly.Memory({initial:19,maximum:16384,shared:true}),
        };
        return {
            __proto__: null,
            "./vodozemac_bindings_dart_bg.js": import0,
        };
    }

    function wasm_bindgen_ae17882a171676a1___convert__closures_____invoke_______true_(arg0, arg1) {
        wasm.wasm_bindgen_ae17882a171676a1___convert__closures_____invoke_______true_(arg0, arg1);
    }

    function wasm_bindgen_ae17882a171676a1___convert__closures_____invoke___web_sys_4d273f66bafd7a9a___features__gen_MessageEvent__MessageEvent______true_(arg0, arg1, arg2) {
        wasm.wasm_bindgen_ae17882a171676a1___convert__closures_____invoke___web_sys_4d273f66bafd7a9a___features__gen_MessageEvent__MessageEvent______true_(arg0, arg1, arg2);
    }

    const WorkerPoolFinalization = (typeof FinalizationRegistry === 'undefined')
        ? { register: () => {}, unregister: () => {} }
        : new FinalizationRegistry(ptr => wasm.__wbg_workerpool_free(ptr, 1));

    function addToExternrefTable0(obj) {
        const idx = wasm.__externref_table_alloc();
        wasm.__wbindgen_externrefs.set(idx, obj);
        return idx;
    }

    const CLOSURE_DTORS = (typeof FinalizationRegistry === 'undefined')
        ? { register: () => {}, unregister: () => {} }
        : new FinalizationRegistry(state => wasm.__wbindgen_destroy_closure(state.a, state.b));

    function debugString(val) {
        switch (typeof val) {
            // primitive types
            case 'number':
            case 'boolean':
            case 'undefined':
            return `${val}`;
            case 'string':
            return JSON.stringify(val);
            case 'bigint':
            return `${val}n`;
            case 'symbol':
            return val.description !== undefined
                ? `Symbol(${val.description})`
                : 'Symbol';
            case 'function':
            return typeof val.name === 'string' && val.name !== ''
                ? `Function(${val.name})`
                : 'Function';
            case 'object': {
                if (val === null) {
                    return 'null';
                }
                // objects
                if (Array.isArray(val)) {
                    return '[' + Array.from(val, debugString).join(', ') + ']';
                }
                // errors
                if (val instanceof Error) {
                    return `${val.name}: ${val.message}\n${val.stack}`;
                }

                const toStringOutput = toString.call(val);
                // Test for built-in
                const className = /\[object ([^\]]+)\]/.exec(toStringOutput)?.[1];

                // Failed to match the standard '[object ClassName]'
                if (className === undefined) {
                    return toStringOutput;
                }
                if (className === 'Object') {
                    // we're a user defined class or Object
                    // JSON.stringify avoids problems with cycles, and is generally much
                    // easier than looping through ownProperties of `val`.
                    try {
                        return 'Object(' + JSON.stringify(val) + ')';
                    } catch (_) {
                        return 'Object';
                    }
                }
                // TODO we could test for more things here, like `Set`s and `Map`s.
                return className;
            }
            // Per MDN: 'This list of values is exhaustive.'
            // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/typeof#description
        }
    }

    function getArrayU8FromWasm0(ptr, len) {
        ptr = ptr >>> 0;
        return getUint8ArrayMemory0().subarray(ptr / 1, ptr / 1 + len);
    }

    let cachedDataViewMemory0 = null;
    function getDataViewMemory0() {
        if (cachedDataViewMemory0 === null || cachedDataViewMemory0.buffer !== wasm.memory.buffer) {
            cachedDataViewMemory0 = new DataView(wasm.memory.buffer);
        }
        return cachedDataViewMemory0;
    }

    function getStringFromWasm0(ptr, len) {
        ptr = ptr >>> 0;
        return decodeText(getUint8ArrayMemory0().subarray(ptr, ptr + len));
    }

    let cachedUint8ArrayMemory0 = null;
    function getUint8ArrayMemory0() {
        if (cachedUint8ArrayMemory0 === null || cachedUint8ArrayMemory0.buffer !== wasm.memory.buffer) {
            cachedUint8ArrayMemory0 = new Uint8Array(wasm.memory.buffer);
        }
        return cachedUint8ArrayMemory0;
    }

    function handleError(f, args) {
        try {
            return f.apply(this, args);
        } catch (e) {
            const idx = addToExternrefTable0(e);
            wasm.__wbindgen_exn_store(idx);
        }
    }

    function isLikeNone(x) {
        return x === undefined || x === null;
    }

    function makeMutClosure(arg0, arg1, f) {
        const state = { a: arg0, b: arg1, cnt: 1 };
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
                state.a = a;
                real._wbg_cb_unref();
            }
        };
        real._wbg_cb_unref = () => {
            if (--state.cnt === 0) {
                wasm.__wbindgen_destroy_closure(state.a, state.b);
                state.a = 0;
                CLOSURE_DTORS.unregister(state);
            }
        };
        CLOSURE_DTORS.register(real, state, state);
        return real;
    }

    function passArray8ToWasm0(arg, malloc) {
        const ptr = malloc(arg.length * 1, 1) >>> 0;
        getUint8ArrayMemory0().set(arg, ptr / 1);
        WASM_VECTOR_LEN = arg.length;
        return ptr;
    }

    function passArrayJsValueToWasm0(array, malloc) {
        const ptr = malloc(array.length * 4, 4) >>> 0;
        for (let i = 0; i < array.length; i++) {
            const add = addToExternrefTable0(array[i]);
            getDataViewMemory0().setUint32(ptr + 4 * i, add, true);
        }
        WASM_VECTOR_LEN = array.length;
        return ptr;
    }

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
            const ret = cachedTextEncoder.encodeInto(arg, view);

            offset += ret.written;
            ptr = realloc(ptr, len, offset, 1) >>> 0;
        }

        WASM_VECTOR_LEN = offset;
        return ptr;
    }

    function takeFromExternrefTable0(idx) {
        const value = wasm.__wbindgen_externrefs.get(idx);
        wasm.__externref_table_dealloc(idx);
        return value;
    }

    let cachedTextDecoder = (typeof TextDecoder !== 'undefined' ? new TextDecoder('utf-8', { ignoreBOM: true }) : undefined);
    if (cachedTextDecoder) cachedTextDecoder.decode();

    function decodeText(bytes) {
        return cachedTextDecoder.decode(bytes.slice());
    }

    const cachedTextEncoder = (typeof TextEncoder !== 'undefined' ? new TextEncoder() : undefined);

    if (cachedTextEncoder) {
        cachedTextEncoder.encodeInto = function (arg, view) {
            const buf = cachedTextEncoder.encode(arg);
            view.set(buf);
            return {
                read: arg.length,
                written: buf.length
            };
        };
    }

    let WASM_VECTOR_LEN = 0;

    let wasmModule, wasmInstance, wasm;
    function __wbg_finalize_init(instance, module, thread_stack_size) {
        wasmInstance = instance;
        wasm = instance.exports;
        wasmModule = module;
        cachedDataViewMemory0 = null;
        cachedUint8ArrayMemory0 = null;
        if (typeof thread_stack_size !== 'undefined' && (typeof thread_stack_size !== 'number' || thread_stack_size === 0 || thread_stack_size % 65536 !== 0)) {
            throw new Error('invalid stack size');
        }

        wasm.__wbindgen_start(thread_stack_size);
        return wasm;
    }

    async function __wbg_load(module, imports) {
        if (typeof Response === 'function' && module instanceof Response) {
            if (!module.ok) {
                throw new Error(`failed to fetch Wasm: ${module.status} ${module.statusText} fetching '${module.url}'`);
            }

            if (typeof WebAssembly.instantiateStreaming === 'function') {
                try {
                    return await WebAssembly.instantiateStreaming(module, imports);
                } catch (e) {
                    const validResponse = expectedResponseType(module.type);

                    if (validResponse && module.headers.get('Content-Type') !== 'application/wasm') {
                        console.warn("`WebAssembly.instantiateStreaming` failed because your server does not serve Wasm with `application/wasm` MIME type. Falling back to `WebAssembly.instantiate` which is slower. Original error:\n", e);

                    } else { throw e; }
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

        function expectedResponseType(type) {
            switch (type) {
                case 'basic': case 'cors': case 'default': return true;
            }
            return false;
        }
    }

    function initSync(module, memory) {
        if (wasm !== undefined) return wasm;

        let thread_stack_size
        if (module !== undefined) {
            if (Object.getPrototypeOf(module) === Object.prototype) {
                ({module, memory, thread_stack_size} = module)
            } else {
                console.warn('using deprecated parameters for `initSync()`; pass a single object instead')
            }
        }

        const imports = __wbg_get_imports(memory);
        if (!(module instanceof WebAssembly.Module)) {
            module = new WebAssembly.Module(module);
        }
        const instance = new WebAssembly.Instance(module, imports);
        return __wbg_finalize_init(instance, module, thread_stack_size);
    }

    let __wbg_init_promise;
    async function __wbg_init(module_or_path, memory) {
        if (wasm !== undefined) return wasm;
        if (__wbg_init_promise === undefined) {
            __wbg_init_promise = __wbg_init_once(module_or_path, memory);
            __wbg_init_promise.catch(() => { __wbg_init_promise = undefined; });
        }
        return __wbg_init_promise;
    }

    async function __wbg_init_once(module_or_path, memory) {
        let thread_stack_size
        if (module_or_path !== undefined) {
            if (Object.getPrototypeOf(module_or_path) === Object.prototype) {
                ({module_or_path, memory, thread_stack_size} = module_or_path)
            } else {
                console.warn('using deprecated parameters for the initialization function; pass a single object instead')
            }
        }

        if (module_or_path === undefined && script_src !== undefined) {
            module_or_path = script_src.replace(/\.js$/, "_bg.wasm");
        }
        const imports = __wbg_get_imports(memory);

        if (typeof module_or_path === 'string' || (typeof Request === 'function' && module_or_path instanceof Request) || (typeof URL === 'function' && module_or_path instanceof URL)) {
            module_or_path = fetch(module_or_path);
        }

        const { instance, module } = await __wbg_load(await module_or_path, imports);

        return __wbg_finalize_init(instance, module, thread_stack_size);
    }

    return Object.assign(__wbg_init, { initSync }, exports);
})({ __proto__: null });
