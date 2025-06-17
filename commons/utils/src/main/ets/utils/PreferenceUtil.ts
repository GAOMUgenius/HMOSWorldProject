import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

class PreferenceUtil {
  private static instance: PreferenceUtil;
  private prefMap: Map<string, preferences.Preferences> = new Map();

  // 单例模式确保全局唯一实例
  public static getInstance(): PreferenceUtil {
    if (!PreferenceUtil.instance) {
      PreferenceUtil.instance = new PreferenceUtil();
    }
    return PreferenceUtil.instance;
  }

  // 加载首选项实例（使用应用上下文）
  async loadPreference(context: common.Context, name: string) {
    try {
      // 确保每个名称只加载一次
      if (!this.prefMap.has(name)) {
        const pref = await preferences.getPreferences(context, name);
        this.prefMap.set(name, pref);
      }
    } catch (e) {
      console.error(`loadPreference error: ${JSON.stringify(e)}`);
    }
  }

  async putPreferenceValue(name: string, key: string, value: preferences.ValueType) {
    try {
      // 确保实例存在
      if (!this.prefMap.has(name)) {
        throw new Error(`Preferences instance ${name} not loaded`);
      }

      const pref = this.prefMap.get(name);
      await pref.put(key, value);
      await pref.flush();
      return true;
    } catch (e) {
      console.error(`putPreferenceValue error: ${JSON.stringify(e)}`);
      return false;
    }
  }

  async getPreferenceValue(name: string, key: string, defaultValue: preferences.ValueType) {
    try {
      // 确保实例存在
      if (!this.prefMap.has(name)) {
        throw new Error(`Preferences instance ${name} not loaded`);
      }

      const pref = this.prefMap.get(name);
      return await pref.get(key, defaultValue);
    } catch (e) {
      console.error(`getPreferenceValue error: ${JSON.stringify(e)}`);
      return defaultValue;
    }
  }
}

export const preferenceUtil = PreferenceUtil.getInstance();
// export { preferenceUtil } as PreferenceUtil;