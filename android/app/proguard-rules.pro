#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

 # Add this global rule
-keepattributes Signature
-keepattributes *Annotation*

-ignorewarnings
-keep class * {
    public private *;
}


# The support library contains references to newer platform versions.
# Don't warn about those in case this app is linking against an older
# platform version.  We know about them, and they are safe.
-dontwarn android.support.**
# Needed by google-http-client to keep generic types and @Key annotations accessed via reflection
-keepclassmembers class * {
  @com.google.api.client.util.Key <fields>;
}
# Needed just to be safe in terms of keeping Google API service model classes
-keep class com.google.api.services.*.model.*
-keep class com.google.api.client.**
-keepattributes Signature,RuntimeVisibleAnnotations,AnnotationDefault
# See https://groups.google.com/forum/#!topic/guava-discuss/YCZzeCiIVoI
-dontwarn com.google.common.collect.MinMaxPriorityQueue
-dontobfuscate
# Assume dependency libraries Just Work(TM)
-dontwarn com.google.android.youtube.**
-dontwarn com.google.android.analytics.**
-dontwarn com.google.common.**
# Don't discard Guava classes that raise warnings
-keep class com.google.common.collect.MapMakerInternalMap$ReferenceEntry
-keep class com.google.common.cache.LocalCache$ReferenceEntry
# Make sure that Google Analytics doesn't get removed
-keep class com.google.analytics.tracking.android.CampaignTrackingReceiver
## BEGIN -- Google Play Services proguard.txt
-keep class * extends java.util.ListResourceBundle {
    protected java.lang.Object[][] getContents();
}
# Keep SafeParcelable value, needed for reflection. This is required to support backwards
# compatibility of some classes.
-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
}
# Keep the names of classes/members we need for client functionality.
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
}
# Needed for Parcelable/SafeParcelable Creators to not get stripped
-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
## END -- Google Play Services proguard.txt
# Other settings
-keep class com.android.** 
-keep class com.google.** 
-keep class com.google.android.** 
-keep class com.google.android.gms.** 
-keep class com.google.android.gms.common.** 
-keep class com.google.android.gms.location.** 
-keep class com.google.api.client.** 
-keep class com.google.maps.android.** 
-keep class libcore.** 
-dontwarn com.google.android.gms.**
-dontwarn org.junit.**

-keep class com.facebook.**
-keep class io.grpc.**
-keep class okio.**
-keep class com.squareup.**
-keep class io.opencensus.**