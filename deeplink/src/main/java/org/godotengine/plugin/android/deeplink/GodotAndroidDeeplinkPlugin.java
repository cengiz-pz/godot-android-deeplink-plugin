package org.godotengine.plugin.android.deeplink;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.verify.domain.DomainVerificationManager;
import android.content.pm.verify.domain.DomainVerificationUserState;
import android.net.Uri;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.UsedByGodot;

import java.util.Map;

public class GodotAndroidDeeplinkPlugin extends GodotPlugin {
    private static final String CLASS_NAME = GodotAndroidDeeplinkPlugin.class.getSimpleName();
    private static final String LOG_TAG = "godot::" + CLASS_NAME;

    public GodotAndroidDeeplinkPlugin(Godot godot) {
        super(godot);
    }

    @UsedByGodot
    public boolean isDomainAssociated(String domain) {
        boolean result = false;
        Activity activity = getActivity();
        if (activity != null) {
            Context context = activity.getApplicationContext();
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                DomainVerificationManager manager = context.getSystemService(DomainVerificationManager.class);
                try {
                    DomainVerificationUserState userState = manager.getDomainVerificationUserState(context.getPackageName());
                    if (userState != null) {
                        Map<String, Integer> hostToStateMap = userState.getHostToStateMap();
                        if (hostToStateMap.containsKey(domain)) {
                            Integer stateValue = hostToStateMap.get(domain);
                            if (stateValue != null) {
                                switch (stateValue) {
                                    case DomainVerificationUserState.DOMAIN_STATE_VERIFIED:
                                        result = true;
                                        Log.i(LOG_TAG, "isDomainAssociated(): state of " + domain + " domain is verified for " + context.getPackageName());
                                        break;
                                    case DomainVerificationUserState.DOMAIN_STATE_SELECTED:
                                        result = true;
                                        Log.i(LOG_TAG, "isDomainAssociated(): state of " + domain + " domain is selected for " + context.getPackageName());
                                        break;
                                    case DomainVerificationUserState.DOMAIN_STATE_NONE:
                                        Log.w(LOG_TAG, "isDomainAssociated(): state of " + domain + " domain is 'none' for " + context.getPackageName());
                                        break;
                                    default:
                                        Log.e(LOG_TAG, "isDomainAssociated(): invalid state of " + domain + " domain for " + context.getPackageName());
                                        break;
                                }
                            }
                            else {
                                Log.e(LOG_TAG, "isDomainAssociated(): state for " + domain + "domain is null for " + context.getPackageName());
                            }
                        }
                        else {
                            Log.e(LOG_TAG, "isDomainAssociated(): state for " + domain + "domain not found for " + context.getPackageName());
                        }
                    }
                } catch (PackageManager.NameNotFoundException e) {
                    Log.e(LOG_TAG, "isDomainAssociated(): package not found: " + context.getPackageName(), e);
                }
            }
            else {
                Log.e(LOG_TAG, "isDomainAssociated(): android version " + android.os.Build.VERSION.SDK_INT + " is not supported. " +
                        android.os.Build.VERSION_CODES.S + " is required.");
            }
        }
        else {
            Log.e(LOG_TAG, "isDomainAssociated(): activity is null");
        }
        return result;
    }

    @UsedByGodot
    public void navigateToOpenByDefaultSettings() {
        Activity activity = getActivity();
        if (activity != null) {
            Context context = activity.getApplicationContext();
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                Intent intent = new Intent(Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS, Uri.parse("package:" + context.getPackageName()));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                Log.i(LOG_TAG, "navigateToOpenByDefaultSettings(): opening 'Open By Default' settings screen.");
                context.startActivity(intent);
            }
            else {
                Log.e(LOG_TAG, "navigateToOpenByDefaultSettings(): android version " + android.os.Build.VERSION.SDK_INT + " is not supported. " +
                        android.os.Build.VERSION_CODES.S + " is required.");
            }
        }
        else {
            Log.e(LOG_TAG, "navigateToOpenByDefaultSettings(): activity is null");
        }
    }

    @UsedByGodot
    public String getUrl() {
        String url = null;
        Activity activity = getActivity();
        if (activity != null) {
            Intent currentIntent = activity.getIntent();

            if (currentIntent != null) {
                url = currentIntent.getDataString();
            }
        }
        Log.d(LOG_TAG, "getUrl() returned " + (url == null ? "null" : url));
        return url;
    }

    @UsedByGodot
    public String getScheme() {
        String scheme = null;

        Activity activity = getActivity();
        if (activity != null) {
            Intent currentIntent = activity.getIntent();

            if (currentIntent != null) {
                Uri uri = currentIntent.getData();
                if (uri != null) {
                    scheme = uri.getScheme();
                }
            }
        }

        Log.d(LOG_TAG, "getScheme() returned " + (scheme == null ? "null" : scheme));
        return scheme;
    }

    @UsedByGodot
    public String getHost() {
        String host = null;

        Activity activity = getActivity();
        if (activity != null) {
            Intent currentIntent = activity.getIntent();

            if (currentIntent != null) {
                Uri uri = currentIntent.getData();
                if (uri != null) {
                    host = uri.getHost();
                }
            }
        }

        Log.d(LOG_TAG, "getHost() returned " + (host == null ? "null" : host));
        return host;
    }

    @UsedByGodot
    public String getPath() {
        String path = null;

        Activity activity = getActivity();
        if (activity != null) {
            Intent currentIntent = activity.getIntent();

            if (currentIntent != null) {
                Uri uri = currentIntent.getData();
                if (uri != null) {
                    path = uri.getPath();
                }
            }
        }

        Log.d(LOG_TAG, "getPath() returned " + (path == null ? "null" : path));
        return path;
    }

    @UsedByGodot
    public void clearData() {
        Activity activity = getActivity();
        if (activity != null) {
            Intent currentIntent = activity.getIntent();

            currentIntent.setData(null);

            Log.d(LOG_TAG, "clearData() " + (currentIntent.getData() == null ? "successfully" : "unsuccessfully") + " cleared");
        }
    }

    @NonNull
    @Override
    public String getPluginName() {
        return CLASS_NAME;
    }
}

