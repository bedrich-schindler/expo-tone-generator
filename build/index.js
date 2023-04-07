import ToneGeneratorModule from "./ToneGeneratorModule";
export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();
export const play = async (frequency) => ToneGeneratorModule.play(frequency);
export const setFrequency = async (frequency) => ToneGeneratorModule.setFrequency(frequency);
export const stop = async () => ToneGeneratorModule.stop();
//# sourceMappingURL=index.js.map