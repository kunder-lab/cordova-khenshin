package com.browser2app;

import android.app.Application;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;


import com.browser2app.khenshin.Khenshin;
import com.browser2app.khenshin.KhenshinInterface;
import com.browser2app.khenshin.KhenshinApplication;

public class CordovaKhenshinApplication extends Application implements KhenshinApplication{

	private static final String TAG = "KhenshinPlugin";
	private Khenshin khenshin;

	@Override
	public KhenshinInterface getKhenshin() {
		return khenshin;
	}

    @Override
    public void onCreate() {
        try {
            ApplicationInfo ai = getPackageManager().getApplicationInfo(this.getPackageName(), PackageManager.GET_META_DATA);
            Bundle bundle = ai.metaData;
            String taskApiUrl = bundle.getString("com.browser2app.TASK_API_URL");
            String dumpApiUrl = bundle.getString("com.browser2app.DUMP_API_URL");
            String mainButtonStyle = bundle.getString("com.browser2app.MAIN_BUTTON_STYLE");
            boolean allowCredentialsSaving = bundle.getBoolean("com.browser2app.ALLOW_CREDENTIALS_SAVING", false);
            boolean hideWebAddress = bundle.getBoolean("com.browser2app.HIDE_WEB_ADDRESS", false);
            int automatonTimeout = bundle.getInt("com.browser2app.AUTOMATON_TIMEOUT", 30);
            boolean skipExitPage = bundle.getBoolean("com.browser2app.SKIP_EXIT_PAGE", false);

            int buttonStyle = Khenshin.CONTINUE_BUTTON_IN_FORM;
            if (mainButtonStyle.equals("CONTINUE_BUTTON_IN_KEYBOARD")) {
                buttonStyle = Khenshin.CONTINUE_BUTTON_IN_KEYBOARD;
            } else if (mainButtonStyle.equals("CONTINUE_BUTTON_IN_TOOLBAR")) {
                buttonStyle = Khenshin.CONTINUE_BUTTON_IN_TOOLBAR;
            }

            khenshin = new Khenshin.KhenshinBuilder()
                    .setApplication(this)
                    .setTaskAPIUrl(taskApiUrl)
                    .setDumpAPIUrl(dumpApiUrl)
                    .setMainButtonStyle(buttonStyle)
                    .setAllowCredentialsSaving(allowCredentialsSaving)
                    .setHideWebAddressInformationInForm(hideWebAddress)
                    .setAutomatonTimeout(automatonTimeout)
                    .setSkipExitPage(skipExitPage)
                    .build();
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(TAG, "Failed to load meta-data, NameNotFound: " + e.getMessage());
        } catch (NullPointerException e) {
            Log.e(TAG, "Failed to load meta-data, NullPointer: " + e.getMessage());
        }
        super.onCreate();
    }

	public CordovaKhenshinApplication() {
	}


}
