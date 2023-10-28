class RecorderProcessor extends AudioWorkletProcessor {
  // Buffer size compromise between size and process call frequency
  bufferSize = 4096
  // The current buffer fill level
  _bytesWritten = 0

  // Create a buffer of fixed size
  _buffers = []

  _numChannels = 1

  constructor(options) {
    super()

    this._numChannels = options.numberOfOutputs

    this.initBuffer()
  }

  initBuffer() {
    this._bytesWritten = 0
    this._buffers = []

    for (let channel = 0; channel < this._numChannels; channel++) {
      this._buffers[channel] = []
    }
  }

  /**
   * @returns {boolean}
   */
  isBufferEmpty() {
    return this._bytesWritten === 0
  }

  /**
   * @returns {boolean}
   */
  isBufferFull() {
    return this._bytesWritten >= this.bufferSize
  }

  /**
   * @param {Float32Array[][]} inputs
   * @returns {boolean}
   */
  process(inputs) {
    if (this.isBufferFull()) {
      this.flush()
    }

    const input = inputs[0]

    for (let channel = 0; channel < this._numChannels; channel++) {
      // Push a copy of the array.
      // The underlying implementation may reuse it which will break the recording.
      this._buffers[channel].push([...input[channel]])
    }

    this._bytesWritten += input[0].length

    return true
  }

  flush() {
    let channels = []
    for (let channel = 0; channel < this._numChannels; channel++) {
      channels.push(this.mergeFloat32Arrays(this._buffers[channel], this._bytesWritten))
    }

    let interleaved = this.interleave(channels)

    this.port.postMessage(this.floatTo16BitPCM(interleaved))

    this.initBuffer()
  }

  mergeFloat32Arrays(arrays, bytesWritten) {
    let result = new Float32Array(bytesWritten)
    var offset = 0

    for (let i = 0; i < arrays.length; i++) {
      result.set(arrays[i], offset)
      offset += arrays[i].length
    }

    return result
  }

  // Interleave data from channels from LLLLLLLLRRRRRRRR to LRLRLRLRLRLRLRLR
  interleave(channels) {
    if (channels === 1) {
      return channels[0]
    }

    var length = 0
    for (let i = 0; i < channels.length; i++) {
      length += channels[i].length
    }

    let result = new Float32Array(length)

    var index = 0
    var inputIndex = 0

    while (index < length) {
      for (let i = 0; i < channels.length; i++) {
        result[index] = channels[i][inputIndex]
        index++
      }

      inputIndex++
    }

    return result
  }

  floatTo16BitPCM(input) {
    let output = new DataView(new ArrayBuffer(input.length * 2))

    for (let i = 0; i < input.length; i++) {
      let s = Math.max(-1, Math.min(1, input[i]))
      let s16 = s < 0 ? s * 0x8000 : s * 0x7FFF
      output.setInt16(i * 2, s16, true)
    }

    return new Int16Array(output.buffer)
  }
}

registerProcessor("recorder.worklet", RecorderProcessor)