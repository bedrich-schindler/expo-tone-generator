import ToneGeneratorModule from "./ToneGeneratorModule";

export const getIsPlaying = () => ToneGeneratorModule.getIsPlaying();

export const play = async (frequency: number) =>
  ToneGeneratorModule.play(frequency);

export const setFrequency = async (frequency: number) =>
  ToneGeneratorModule.setFrequency(frequency);

export const stop = async () => ToneGeneratorModule.stop();
