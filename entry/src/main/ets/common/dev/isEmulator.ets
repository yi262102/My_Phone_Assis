import { deviceInfo } from '@kit.BasicServicesKit'

/**
 * 是否为模拟器
 * @returns boolean
 */
export function isEmulator() {
  return deviceInfo.marketName === 'emulator'
}

/**
 * 是否为不为模拟器
 * @returns boolean
 */
export function isNoteEmulator() {
  return deviceInfo.marketName !== 'emulator'
}