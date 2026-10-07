# slf4j binding is a transitive reference not bundled in this app; suppress the
# R8 missing-class error for it.
-dontwarn org.slf4j.**
