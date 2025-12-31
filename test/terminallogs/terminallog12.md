PS D:\solutions\MuslimLifeAI_demo\android> flutter clean
Changing current working directory to: D:\solutions\MuslimLifeAI_demo
Deleting build...                                                   3.4s
Deleting .dart_tool...                                              54ms
Deleting ephemeral...                                                0ms
Deleting Generated.xcconfig...                                       1ms
Deleting flutter_export_environment.sh...                            0ms
Deleting ephemeral...                                                1ms
Deleting ephemeral...                                                1ms
Deleting ephemeral...                                                3ms
Deleting .flutter-plugins-dependencies...                            0ms
PS D:\solutions\MuslimLifeAI_demo\android> flutter run -d emulator-5554 
Changing current working directory to: D:\solutions\MuslimLifeAI_demo
Resolving dependencies... 
Downloading packages... 
  audio_session 0.1.25 (0.2.2 available)
  characters 1.4.0 (1.4.1 available)
  flutter_launcher_icons 0.13.1 (0.14.4 available)
  flutter_lints 3.0.2 (6.0.0 available)
  flutter_timezone 3.0.1 (5.0.1 available)
  geocoding_platform_interface 3.2.0 (5.0.0 available)
  geolocator 13.0.4 (14.0.2 available)
  geolocator_android 4.6.2 (5.0.2 available)
  glass_kit 3.0.0 (4.0.2 available)
  intl 0.19.0 (0.20.2 available)
  just_audio 0.9.46 (0.10.5 available)
  lints 3.0.0 (6.0.0 available)
  matcher 0.12.17 (0.12.18 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  permission_handler 11.4.0 (12.0.1 available)
  permission_handler_android 12.1.0 (13.0.1 available)
  quran 1.2.9 (1.4.1 available)
  test_api 0.7.7 (0.7.8 available)
Got dependencies!
18 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
Launching lib\main.dart on sdk gphone64 x86 64 in debug mode...
e: Daemon compilation failed: null
java.lang.Exception
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:69)
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:65)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemon(GradleKotlinCompilerWork.kt:240)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemonOrFallbackImpl(GradleKotlinCompilerWork.kt:159)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.run(GradleKotlinCompilerWork.kt:111)
        at org.jetbrains.kotlin.compilerRunner.GradleCompilerRunnerWithWorkers$GradleKotlinCompilerWorkAction.execute(GradleCompilerRunnerWithWorkers.kt:74)
        at org.gradle.workers.internal.DefaultWorkerServer.execute(DefaultWorkerServer.java:63)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:66)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:62)
        at org.gradle.internal.classloader.ClassLoaderUtils.executeInClassloader(ClassLoaderUtils.java:100)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.lambda$execute$0(NoIsolationWorkerFactory.java:62)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:44)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:41)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:210)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:205)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:67)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:167)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.call(DefaultBuildOperationRunner.java:54)
        at org.gradle.workers.internal.AbstractWorker.executeWrappedInBuildOperation(AbstractWorker.java:41)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.execute(NoIsolationWorkerFactory.java:59)
        at org.gradle.workers.internal.DefaultWorkerExecutor.lambda$submitWork$0(DefaultWorkerExecutor.java:174)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runExecution(DefaultConditionalExecutionQueue.java:194)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.access$700(DefaultConditionalExecutionQueue.java:127)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner$1.run(DefaultConditionalExecutionQueue.java:169)
        at org.gradle.internal.Factories$1.create(Factories.java:31)
        at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:263)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:127)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:132)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runBatch(DefaultConditionalExecutionQueue.java:164)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.run(DefaultConditionalExecutionQueue.java:133)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:64)
        at org.gradle.internal.concurrent.AbstractManagedExecutor$1.run(AbstractManagedExecutor.java:48)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
        at java.base/java.lang.Thread.run(Unknown Source)
Caused by: java.lang.AssertionError: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                            
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:218)
        at org.jetbrains.kotlin.incremental.IncrementalCachesManager.close(IncrementalCachesManager.kt:55)
        at kotlin.io.CloseableKt.closeFinally(Closeable.kt:46)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compileNonIncrementally(IncrementalCompilerRunner.kt:293)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compile(IncrementalCompilerRunner.kt:128)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.execIncrementalCompiler(CompileServiceImpl.kt:684)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.access$execIncrementalCompiler(CompileServiceImpl.kt:94)
        at org.jetbrains.kotlin.daemon.CompileServiceImpl.compile(CompileServiceImpl.kt:1810)
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source)
        at java.base/java.lang.reflect.Method.invoke(Unknown Source)
        at java.rmi/sun.rmi.server.UnicastServerRef.dispatch(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport.serviceCall(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport.handleMessages(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$0(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(Unknown Source)
        ... 3 more
Caused by: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                                      
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:205)
        ... 22 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\android_alarm_manager_plus-5.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\androidalarmmanager\AlarmBroadcastReceiver.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                 
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\android_alarm_manager_plus-5.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\androidalarmmanager\AlarmBroadcastReceiver.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                 
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\android_alarm_manager_plus-5.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\androidalarmmanager\AlarmBroadcastReceiver.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                 
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:151)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:142)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\android_alarm_manager_plus-5.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\androidalarmmanager\AlarmBroadcastReceiver.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                         
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:51)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:48)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\android_alarm_manager_plus-5.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\androidalarmmanager\AlarmBroadcastReceiver.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                         
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\android_alarm_manager_plus-5.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\androidalarmmanager\AlarmBroadcastReceiver.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                         
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more

Note: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\android_alarm_manager_plus-5.0.0\android\src\main\java\dev\fluttercommunity\plus\androidalarmmanager\AlarmService.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
3 warnings
warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
3 warnings
Note: Some input files use or override a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
3 warnings
warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
e: Daemon compilation failed: null
java.lang.Exception
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:69)
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:65)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemon(GradleKotlinCompilerWork.kt:240)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemonOrFallbackImpl(GradleKotlinCompilerWork.kt:159)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.run(GradleKotlinCompilerWork.kt:111)
        at org.jetbrains.kotlin.compilerRunner.GradleCompilerRunnerWithWorkers$GradleKotlinCompilerWorkAction.execute(GradleCompilerRunnerWithWorkers.kt:74)
        at org.gradle.workers.internal.DefaultWorkerServer.execute(DefaultWorkerServer.java:63)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:66)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:62)
        at org.gradle.internal.classloader.ClassLoaderUtils.executeInClassloader(ClassLoaderUtils.java:100)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.lambda$execute$0(NoIsolationWorkerFactory.java:62)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:44)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:41)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:210)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:205)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:67)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:167)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.call(DefaultBuildOperationRunner.java:54)
        at org.gradle.workers.internal.AbstractWorker.executeWrappedInBuildOperation(AbstractWorker.java:41)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.execute(NoIsolationWorkerFactory.java:59)
        at org.gradle.workers.internal.DefaultWorkerExecutor.lambda$submitWork$0(DefaultWorkerExecutor.java:174)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runExecution(DefaultConditionalExecutionQueue.java:194)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.access$700(DefaultConditionalExecutionQueue.java:127)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner$1.run(DefaultConditionalExecutionQueue.java:169)
        at org.gradle.internal.Factories$1.create(Factories.java:31)
        at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:263)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:127)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:132)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runBatch(DefaultConditionalExecutionQueue.java:164)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.run(DefaultConditionalExecutionQueue.java:133)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:64)
        at org.gradle.internal.concurrent.AbstractManagedExecutor$1.run(AbstractManagedExecutor.java:48)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
        at java.base/java.lang.Thread.run(Unknown Source)
Caused by: java.lang.AssertionError: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                      
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:218)
        at org.jetbrains.kotlin.incremental.IncrementalCachesManager.close(IncrementalCachesManager.kt:55)
        at kotlin.io.CloseableKt.closeFinally(Closeable.kt:46)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compileNonIncrementally(IncrementalCompilerRunner.kt:293)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compile(IncrementalCompilerRunner.kt:128)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.execIncrementalCompiler(CompileServiceImpl.kt:684)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.access$execIncrementalCompiler(CompileServiceImpl.kt:94)
        at org.jetbrains.kotlin.daemon.CompileServiceImpl.compile(CompileServiceImpl.kt:1810)
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source)
        at java.base/java.lang.reflect.Method.invoke(Unknown Source)
        at java.rmi/sun.rmi.server.UnicastServerRef.dispatch(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport.serviceCall(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport.handleMessages(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$0(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(Unknown Source)
        ... 3 more
Caused by: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                                                
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:205)
        ... 22 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_timezone-3.0.1\android\src\main\kotlin\net\wolverinebeach\flutter_timezone\FlutterTimezonePlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                      
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_timezone-3.0.1\android\src\main\kotlin\net\wolverinebeach\flutter_timezone\FlutterTimezonePlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                      
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_timezone-3.0.1\android\src\main\kotlin\net\wolverinebeach\flutter_timezone\FlutterTimezonePlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                      
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:151)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:142)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_timezone-3.0.1\android\src\main\kotlin\net\wolverinebeach\flutter_timezone\FlutterTimezonePlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                              
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:51)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:48)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_timezone-3.0.1\android\src\main\kotlin\net\wolverinebeach\flutter_timezone\FlutterTimezonePlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                              
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_timezone-3.0.1\android\src\main\kotlin\net\wolverinebeach\flutter_timezone\FlutterTimezonePlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                              
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more

3 warnings
warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
3 warnings
e: Daemon compilation failed: null
java.lang.Exception
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:69)
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:65)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemon(GradleKotlinCompilerWork.kt:240)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemonOrFallbackImpl(GradleKotlinCompilerWork.kt:159)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.run(GradleKotlinCompilerWork.kt:111)
        at org.jetbrains.kotlin.compilerRunner.GradleCompilerRunnerWithWorkers$GradleKotlinCompilerWorkAction.execute(GradleCompilerRunnerWithWorkers.kt:74)
        at org.gradle.workers.internal.DefaultWorkerServer.execute(DefaultWorkerServer.java:63)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:66)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:62)
        at org.gradle.internal.classloader.ClassLoaderUtils.executeInClassloader(ClassLoaderUtils.java:100)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.lambda$execute$0(NoIsolationWorkerFactory.java:62)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:44)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:41)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:210)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:205)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:67)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:167)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.call(DefaultBuildOperationRunner.java:54)
        at org.gradle.workers.internal.AbstractWorker.executeWrappedInBuildOperation(AbstractWorker.java:41)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.execute(NoIsolationWorkerFactory.java:59)
        at org.gradle.workers.internal.DefaultWorkerExecutor.lambda$submitWork$0(DefaultWorkerExecutor.java:174)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runExecution(DefaultConditionalExecutionQueue.java:194)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.access$700(DefaultConditionalExecutionQueue.java:127)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner$1.run(DefaultConditionalExecutionQueue.java:169)
        at org.gradle.internal.Factories$1.create(Factories.java:31)
        at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:263)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:127)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:132)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runBatch(DefaultConditionalExecutionQueue.java:164)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.run(DefaultConditionalExecutionQueue.java:133)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:64)
        at org.gradle.internal.concurrent.AbstractManagedExecutor$1.run(AbstractManagedExecutor.java:48)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
        at java.base/java.lang.Thread.run(Unknown Source)
Caused by: java.lang.AssertionError: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                     
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:218)
        at org.jetbrains.kotlin.incremental.IncrementalCachesManager.close(IncrementalCachesManager.kt:55)
        at kotlin.io.CloseableKt.closeFinally(Closeable.kt:46)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compileNonIncrementally(IncrementalCompilerRunner.kt:293)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compile(IncrementalCompilerRunner.kt:128)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.execIncrementalCompiler(CompileServiceImpl.kt:684)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.access$execIncrementalCompiler(CompileServiceImpl.kt:94)
        at org.jetbrains.kotlin.daemon.CompileServiceImpl.compile(CompileServiceImpl.kt:1810)
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source)
        at java.base/java.lang.reflect.Method.invoke(Unknown Source)
        at java.rmi/sun.rmi.server.UnicastServerRef.dispatch(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport.serviceCall(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport.handleMessages(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$0(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(Unknown Source)
        ... 3 more
Caused by: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                                               
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:205)
        ... 22 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\package_info_plus-9.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\packageinfo\PackageInfoPlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                       
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\package_info_plus-9.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\packageinfo\PackageInfoPlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                       
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\package_info_plus-9.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\packageinfo\PackageInfoPlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                       
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:151)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:142)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\package_info_plus-9.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\packageinfo\PackageInfoPlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                               
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:51)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:48)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\package_info_plus-9.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\packageinfo\PackageInfoPlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                               
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\package_info_plus-9.0.0\android\src\main\kotlin\dev\fluttercommunity\plus\packageinfo\PackageInfoPlugin.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                               
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more

warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
3 warnings
e: Daemon compilation failed: null
java.lang.Exception
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:69)
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:65)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemon(GradleKotlinCompilerWork.kt:240)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemonOrFallbackImpl(GradleKotlinCompilerWork.kt:159)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.run(GradleKotlinCompilerWork.kt:111)
        at org.jetbrains.kotlin.compilerRunner.GradleCompilerRunnerWithWorkers$GradleKotlinCompilerWorkAction.execute(GradleCompilerRunnerWithWorkers.kt:74)
        at org.gradle.workers.internal.DefaultWorkerServer.execute(DefaultWorkerServer.java:63)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:66)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:62)
        at org.gradle.internal.classloader.ClassLoaderUtils.executeInClassloader(ClassLoaderUtils.java:100)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.lambda$execute$0(NoIsolationWorkerFactory.java:62)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:44)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:41)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:210)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:205)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:67)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:167)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.call(DefaultBuildOperationRunner.java:54)
        at org.gradle.workers.internal.AbstractWorker.executeWrappedInBuildOperation(AbstractWorker.java:41)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.execute(NoIsolationWorkerFactory.java:59)
        at org.gradle.workers.internal.DefaultWorkerExecutor.lambda$submitWork$0(DefaultWorkerExecutor.java:174)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runExecution(DefaultConditionalExecutionQueue.java:194)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.access$700(DefaultConditionalExecutionQueue.java:127)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner$1.run(DefaultConditionalExecutionQueue.java:169)
        at org.gradle.internal.Factories$1.create(Factories.java:31)
        at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:263)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:127)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:132)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runBatch(DefaultConditionalExecutionQueue.java:164)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.run(DefaultConditionalExecutionQueue.java:133)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:64)
        at org.gradle.internal.concurrent.AbstractManagedExecutor$1.run(AbstractManagedExecutor.java:48)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
        at java.base/java.lang.Thread.run(Unknown Source)
Caused by: java.lang.AssertionError: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                            
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:218)
        at org.jetbrains.kotlin.incremental.IncrementalCachesManager.close(IncrementalCachesManager.kt:55)
        at kotlin.io.CloseableKt.closeFinally(Closeable.kt:46)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compileNonIncrementally(IncrementalCompilerRunner.kt:293)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compile(IncrementalCompilerRunner.kt:128)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.execIncrementalCompiler(CompileServiceImpl.kt:684)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.access$execIncrementalCompiler(CompileServiceImpl.kt:94)
        at org.jetbrains.kotlin.daemon.CompileServiceImpl.compile(CompileServiceImpl.kt:1810)
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source)
        at java.base/java.lang.reflect.Method.invoke(Unknown Source)
        at java.rmi/sun.rmi.server.UnicastServerRef.dispatch(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport.serviceCall(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport.handleMessages(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$0(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(Unknown Source)
        ... 3 more
Caused by: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                                      
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:205)
        ... 22 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.18\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.18\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.18\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:151)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:142)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.18\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                        
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:51)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:48)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.18\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                        
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.18\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                        
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more

e: Daemon compilation failed: null
java.lang.Exception
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:69)
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:65)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemon(GradleKotlinCompilerWork.kt:240)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemonOrFallbackImpl(GradleKotlinCompilerWork.kt:159)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.run(GradleKotlinCompilerWork.kt:111)
        at org.jetbrains.kotlin.compilerRunner.GradleCompilerRunnerWithWorkers$GradleKotlinCompilerWorkAction.execute(GradleCompilerRunnerWithWorkers.kt:74)
        at org.gradle.workers.internal.DefaultWorkerServer.execute(DefaultWorkerServer.java:63)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:66)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:62)
        at org.gradle.internal.classloader.ClassLoaderUtils.executeInClassloader(ClassLoaderUtils.java:100)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.lambda$execute$0(NoIsolationWorkerFactory.java:62)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:44)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:41)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:210)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:205)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:67)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:167)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.call(DefaultBuildOperationRunner.java:54)
        at org.gradle.workers.internal.AbstractWorker.executeWrappedInBuildOperation(AbstractWorker.java:41)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.execute(NoIsolationWorkerFactory.java:59)
        at org.gradle.workers.internal.DefaultWorkerExecutor.lambda$submitWork$0(DefaultWorkerExecutor.java:174)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runExecution(DefaultConditionalExecutionQueue.java:194)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.access$700(DefaultConditionalExecutionQueue.java:127)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner$1.run(DefaultConditionalExecutionQueue.java:169)
        at org.gradle.internal.Factories$1.create(Factories.java:31)
        at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:263)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:127)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:132)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runBatch(DefaultConditionalExecutionQueue.java:164)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.run(DefaultConditionalExecutionQueue.java:133)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:64)
        at org.gradle.internal.concurrent.AbstractManagedExecutor$1.run(AbstractManagedExecutor.java:48)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
        at java.base/java.lang.Thread.run(Unknown Source)
Caused by: java.lang.AssertionError: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                         
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:218)
        at org.jetbrains.kotlin.incremental.IncrementalCachesManager.close(IncrementalCachesManager.kt:55)
        at kotlin.io.CloseableKt.closeFinally(Closeable.kt:46)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compileNonIncrementally(IncrementalCompilerRunner.kt:293)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compile(IncrementalCompilerRunner.kt:128)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.execIncrementalCompiler(CompileServiceImpl.kt:684)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.access$execIncrementalCompiler(CompileServiceImpl.kt:94)
        at org.jetbrains.kotlin.daemon.CompileServiceImpl.compile(CompileServiceImpl.kt:1810)
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source)
        at java.base/java.lang.reflect.Method.invoke(Unknown Source)
        at java.rmi/sun.rmi.server.UnicastServerRef.dispatch(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport.serviceCall(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport.handleMessages(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$0(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(Unknown Source)
        ... 3 more
Caused by: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab                                                                                                                                                                                                                                   
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:205)
        ... 22 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\wakelock_plus-1.4.0\android\src\main\kotlin\dev\fluttercommunity\plus\wakelock\Wakelock.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                                       
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\wakelock_plus-1.4.0\android\src\main\kotlin\dev\fluttercommunity\plus\wakelock\Wakelock.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                                       
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\wakelock_plus-1.4.0\android\src\main\kotlin\dev\fluttercommunity\plus\wakelock\Wakelock.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                                       
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:151)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:142)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\wakelock_plus-1.4.0\android\src\main\kotlin\dev\fluttercommunity\plus\wakelock\Wakelock.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                               
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:51)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:48)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\wakelock_plus-1.4.0\android\src\main\kotlin\dev\fluttercommunity\plus\wakelock\Wakelock.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                               
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: C:\Users\Masoud\AppData\Local\Pub\Cache\hosted\pub.dev\wakelock_plus-1.4.0\android\src\main\kotlin\dev\fluttercommunity\plus\wakelock\Wakelock.kt and D:\solutions\MuslimLifeAI_demo\android.                                                                                                                                                                                               
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more

Running Gradle task 'assembleDebug'...                            116.2s
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing ..\build\app\outputs\flutter-apk\app-debug.apk...      2,934ms
D/FlutterJNI( 5187): Beginning load of flutter...
D/FlutterJNI( 5187): flutter (null) was loaded normally!
I/flutter ( 5187): [IMPORTANT:flutter/shell/platform/android/android_context_gl_impeller.cc(104)] Using the Impeller rendering backend (OpenGLES).
D/FlutterGeolocator( 5187): Attaching Geolocator to activity
W/.muslimlife.app( 5187): Accessing hidden method Landroid/view/accessibility/AccessibilityNodeInfo;->getSourceNodeId()J (unsupported,test-api, reflection, allowed)
W/.muslimlife.app( 5187): Accessing hidden method Landroid/view/accessibility/AccessibilityRecord;->getSourceNodeId()J (unsupported, reflection, allowed)
W/.muslimlife.app( 5187): Accessing hidden field Landroid/view/accessibility/AccessibilityNodeInfo;->mChildNodeIds:Landroid/util/LongArray; (unsupported, reflection, allowed)
W/.muslimlife.app( 5187): Accessing hidden method Landroid/util/LongArray;->get(I)J (unsupported, reflection, allowed)
D/CompatibilityChangeReporter( 5187): Compat change id reported: 237531167; UID 10177; state: DISABLED
W/Parcel  ( 5187): Expecting binder but got null!
I/Choreographer( 5187): Skipped 190 frames!  The application may be doing too much work on its main thread.
D/HostConnection( 5187): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 
W/OpenGLRenderer( 5187): Failed to choose config with EGL_SWAP_BEHAVIOR_PRESERVED, retrying without...
W/OpenGLRenderer( 5187): Failed to initialize 101010-2 format, error = EGL_SUCCESS
D/EGL_emulation( 5187): eglCreateContext: 0x7e0d9c049610: maj 3 min 1 rcv 4
I/Gralloc4( 5187): mapper 4.x is not supported
D/EGL_emulation( 5187): eglMakeCurrent: 0x7e0d9c049610: ver 3 1 (tinfo 0x7e0fc397a180) (first time)
W/Gralloc4( 5187): allocator 4.x is not supported
D/HostConnection( 5187): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 
E/OpenGLRenderer( 5187): Unable to match the desired swap behavior.
D/FlutterGeolocator( 5187): Creating service.
D/FlutterGeolocator( 5187): Binding to location service.
I/Choreographer( 5187): Skipped 37 frames!  The application may be doing too much work on its main thread.
D/FlutterGeolocator( 5187): Geolocator foreground service connected
D/FlutterGeolocator( 5187): Initializing Geolocator services
D/FlutterGeolocator( 5187): Flutter engine connected. Connected engine count 1
I/flutter ( 5187): Firebase already initialized
I/FlutterBackgroundExecutor( 5187): Starting AlarmService...
I/AndroidAlarmManagerPlugin( 5187): onAttachedToEngine
Syncing files to device sdk gphone64 x86 64...                     284ms
D/HostConnection( 5187): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 

Flutter run key commands.
r Hot reload. 
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on sdk gphone64 x86 64 is available at: http://127.0.0.1:54520/ZUmZi1--ZT4=/
The Flutter DevTools debugger and profiler on sdk gphone64 x86 64 is available at: http://127.0.0.1:54520/ZUmZi1--ZT4=/devtools/?uri=ws://127.0.0.1:54520/ZUmZi1--ZT4=/ws
D/EGL_emulation( 5187): eglCreateContext: 0x7e0d9c047750: maj 3 min 1 rcv 4
D/EGL_emulation( 5187): eglCreateContext: 0x7e0d9c048f50: maj 3 min 1 rcv 4
D/EGL_emulation( 5187): eglMakeCurrent: 0x7e0d9c048f50: ver 3 1 (tinfo 0x7e0fc397a200) (first time)
I/flutter ( 5187): [IMPORTANT:flutter/shell/platform/android/android_context_gl_impeller.cc(104)] Using the Impeller rendering backend (OpenGLES).
D/HostConnection( 5187): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 
D/EGL_emulation( 5187): eglMakeCurrent: 0x7e0d9c048f50: ver 3 1 (tinfo 0x7e0fc397a280) (first time)
I/flutter ( 5187): UnifiedAudioService: AndroidAlarmManager initialized.
I/flutter ( 5187): Firebase Emulator connection is currently disabled. Connecting to LIVE Firebase.
I/Choreographer( 5187): Skipped 40 frames!  The application may be doing too much work on its main thread.
I/flutter ( 5187): Auth State Chain: ConnectionState.waiting | HasData: false | Error: null
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): Auth State Chain: ConnectionState.active | HasData: false | Error: null
I/flutter ( 5187): No user detected. Showing Landing/Intro.
D/FlutterGeolocator( 5187): Geolocator foreground service connected
D/FlutterGeolocator( 5187): Initializing Geolocator services
D/FlutterGeolocator( 5187): Flutter engine connected. Connected engine count 2
I/AlarmService( 5187): AlarmService started!
I/Choreographer( 5187): Skipped 68 frames!  The application may be doing too much work on its main thread.
I/OpenGLRenderer( 5187): Davey! duration=1183ms; Flags=1, FrameTimelineVsyncId=73822049, IntendedVsync=428352839300020, Vsync=428353972633308, InputEventId=0, HandleInputStart=428353976767600, AnimationStart=428353976785200, PerformTraversalsStart=428353976813400, DrawStart=428353977264000, FrameDeadline=428352855966686, FrameInterval=428353976571000, FrameStartTime=16666666, SyncQueued=428353979345400, SyncStart=428353986266600, IssueDrawCommandsStart=428353986335500, SwapBuffers=428354006969100, FrameCompleted=428354029541900, DequeueBufferDuration=17342700, QueueBufferDuration=286700, GpuCompleted=428354023354500, SwapBuffersCompleted=428354029541900, DisplayPresentTime=0, CommandSubmissionCompleted=428354006969100, 
D/EGL_emulation( 5187): app_time_stats: avg=119.07ms min=6.68ms max=1098.44ms count=17
W/OnBackInvokedCallback( 5187): OnBackInvokedCallback is not enabled for the application.
W/OnBackInvokedCallback( 5187): Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.
D/ProfileInstaller( 5187): Installing profile for ai.muslimlife.app
D/InputMethodManager( 5187): showSoftInput() view=io.flutter.embedding.android.FlutterView{6455e3a VFE...... .F....ID 0,0-1080,2337 #1 aid=1073741824} flags=0 reason=SHOW_SOFT_INPUT
D/EGL_emulation( 5187): app_time_stats: avg=1854.25ms min=149.61ms max=3558.88ms count=2
I/AssistStructure( 5187): Flattened final assist data: 444 bytes, containing 1 windows, 3 views
D/EGL_emulation( 5187): app_time_stats: avg=62.92ms min=6.46ms max=945.05ms count=28
D/InsetsController( 5187): show(ime(), fromIme=true)
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
D/EGL_emulation( 5187): app_time_stats: avg=72.35ms min=11.57ms max=449.51ms count=18
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
D/EGL_emulation( 5187): app_time_stats: avg=143.28ms min=33.45ms max=499.95ms count=7
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
D/EGL_emulation( 5187): app_time_stats: avg=100.78ms min=21.97ms max=483.78ms count=14
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
D/EGL_emulation( 5187): app_time_stats: avg=472.08ms min=443.75ms max=499.06ms count=3
D/EGL_emulation( 5187): app_time_stats: avg=280.65ms min=167.00ms max=433.69ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=387.26ms min=167.41ms max=501.72ms count=3
I/TextInputPlugin( 5187): Composing region changed by the framework. Restarting the input method.
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getTextBeforeCursor on inactive InputConnection
W/RemoteInputConnectionImpl( 5187): getSurroundingText on inactive InputConnection
D/InsetsController( 5187): show(ime(), fromIme=true)
D/EGL_emulation( 5187): app_time_stats: avg=426.79ms min=297.47ms max=497.91ms count=3
D/EGL_emulation( 5187): app_time_stats: avg=254.37ms min=73.80ms max=492.93ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=362.88ms min=254.28ms max=501.11ms count=3
D/InputMethodManager( 5187): showSoftInput() view=io.flutter.embedding.android.FlutterView{6455e3a VFE...... .F...... 0,0-1080,2337 #1 aid=1073741824} flags=0 reason=SHOW_SOFT_INPUT
D/InputMethodManager( 5187): showSoftInput() view=io.flutter.embedding.android.FlutterView{6455e3a VFE...... .F...... 0,0-1080,2337 #1 aid=1073741824} flags=0 reason=SHOW_SOFT_INPUT
I/AssistStructure( 5187): Flattened final assist data: 444 bytes, containing 1 windows, 3 views
D/InsetsController( 5187): show(ime(), fromIme=true)
D/InsetsController( 5187): show(ime(), fromIme=true)
D/EGL_emulation( 5187): app_time_stats: avg=76.06ms min=4.49ms max=280.21ms count=13
D/EGL_emulation( 5187): app_time_stats: avg=171.59ms min=7.70ms max=503.21ms count=6
D/EGL_emulation( 5187): app_time_stats: avg=206.75ms min=99.24ms max=493.51ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=331.25ms min=249.23ms max=494.02ms count=4
I/FirebaseAuth( 5187): Logging in as masoudtest@test.com with empty reCAPTCHA token
W/System  ( 5187): Ignoring header X-Firebase-Locale because its value was null.
D/EGL_emulation( 5187): app_time_stats: avg=96.29ms min=4.49ms max=499.95ms count=10
D/TrafficStats( 5187): tagSocket(128) with statsTag=0xffffffff, statsUid=-1
W/System  ( 5187): Ignoring header X-Firebase-Locale because its value was null.
D/FirebaseAuth( 5187): Notifying id token listeners about user ( MnNcvOKRSkOiXmgIfFmNMRnbNWB3 ).
D/FirebaseAuth( 5187): Notifying auth state listeners about user ( MnNcvOKRSkOiXmgIfFmNMRnbNWB3 ).
I/flutter ( 5187): PrayerService: Fetching prayer times...
D/EGL_emulation( 5187): app_time_stats: avg=15.81ms min=3.70ms max=322.27ms count=42
I/flutter ( 5187): PrayerService: Fetching prayer times...
W/OnBackInvokedCallback( 5187): OnBackInvokedCallback is not enabled for the application.
W/OnBackInvokedCallback( 5187): Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.
D/EGL_emulation( 5187): app_time_stats: avg=879.69ms min=1.63ms max=16836.43ms count=20
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
W/Activity( 5187): Can request only one set of permissions at a time
I/Geolocator( 5187): The grantResults array is empty. This can happen when the user cancels the permission request
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
W/Activity( 5187): Can request only one set of permissions at a time
I/Geolocator( 5187): The grantResults array is empty. This can happen when the user cancels the permission request
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: NULL
D/EGL_emulation( 5187): app_time_stats: avg=126.85ms min=26.91ms max=321.12ms count=8
D/EGL_emulation( 5187): app_time_stats: avg=40.16ms min=7.02ms max=177.48ms count=24
D/EGL_emulation( 5187): app_time_stats: avg=22.36ms min=6.80ms max=149.72ms count=44
D/EGL_emulation( 5187): app_time_stats: avg=9.51ms min=5.85ms max=26.01ms count=61
D/CompatibilityChangeReporter( 5187): Compat change id reported: 78294732; UID 10177; state: ENABLED
I/flutter ( 5187): QiblaScreen: Fetching last known position...
I/flutter ( 5187): QiblaScreen: Requesting current position (45s limit)...
D/EGL_emulation( 5187): app_time_stats: avg=10.39ms min=5.75ms max=72.97ms count=56
D/EGL_emulation( 5187): app_time_stats: avg=8.69ms min=5.80ms max=23.68ms count=61
D/EGL_emulation( 5187): app_time_stats: avg=8.77ms min=5.89ms max=60.45ms count=58
D/EGL_emulation( 5187): app_time_stats: avg=9.15ms min=6.25ms max=28.41ms count=59
D/EGL_emulation( 5187): app_time_stats: avg=16.49ms min=12.32ms max=22.03ms count=60
D/EGL_emulation( 5187): app_time_stats: avg=17.18ms min=13.65ms max=22.31ms count=57
D/EGL_emulation( 5187): app_time_stats: avg=13.40ms min=7.75ms max=29.75ms count=57
I/flutter ( 5187): TRACE: UnifiedAudioService.stop() called. Current Session: 0
I/flutter ( 5187): ExpandableAudioPlayer: Build. Surah: Al-Ikhlas
I/flutter ( 5187): UnifiedAudioService: Fetching precision timestamps for Surah 112...
W/OnBackInvokedCallback( 5187): OnBackInvokedCallback is not enabled for the application.
W/OnBackInvokedCallback( 5187): Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.
D/EGL_emulation( 5187): app_time_stats: avg=1860.66ms min=10.17ms max=10502.76ms count=6
I/flutter ( 5187): Creating new copy of ayahinfo.db from assets
I/flutter ( 5187): db copied successfully
I/flutter ( 5187): ✅ MushafTextService initialized. Loaded 604 pages.
D/EGL_emulation( 5187): app_time_stats: avg=29.46ms min=8.13ms max=214.96ms count=31
D/EGL_emulation( 5187): app_time_stats: avg=254.40ms min=5.59ms max=942.68ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=200.24ms min=8.76ms max=943.44ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=198.69ms min=8.77ms max=939.95ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=199.38ms min=4.58ms max=943.35ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=254.16ms min=16.08ms max=958.83ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=381.92ms min=8.92ms max=943.09ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=250.45ms min=15.36ms max=953.11ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=197.92ms min=10.37ms max=915.59ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=244.42ms min=8.45ms max=943.71ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=250.08ms min=15.02ms max=947.81ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=201.83ms min=9.83ms max=956.11ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=200.21ms min=7.67ms max=942.49ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=386.08ms min=7.78ms max=950.16ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=202.94ms min=13.10ms max=951.75ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=250.44ms min=14.17ms max=952.84ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=200.73ms min=7.70ms max=936.15ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=195.14ms min=6.38ms max=943.04ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=389.80ms min=14.12ms max=959.44ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=198.32ms min=6.53ms max=925.26ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=196.64ms min=6.78ms max=943.43ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=244.48ms min=5.41ms max=943.60ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=253.82ms min=16.98ms max=953.32ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=200.38ms min=13.65ms max=938.81ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=260.71ms min=13.51ms max=953.40ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=382.05ms min=13.08ms max=952.99ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=249.97ms min=12.48ms max=954.58ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=202.49ms min=13.06ms max=952.09ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=250.16ms min=14.90ms max=953.72ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=250.01ms min=14.36ms max=954.42ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=202.88ms min=13.51ms max=951.25ms count=5
D/EGL_emulation( 5187): app_time_stats: avg=250.11ms min=12.73ms max=954.72ms count=4
D/EGL_emulation( 5187): app_time_stats: avg=201.42ms min=7.71ms max=951.88ms count=5
I/flutter ( 5187): QiblaScreen: Location error: TimeoutException after 0:00:45.000000: Future not completed. Using generic fallback.

══╡ EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE ╞════════════════════════════════════════════════════
The following assertion was thrown resolving an image codec:
Unable to load asset: "assets/images/compass_dial.png".
Exception: Asset not found

When the exception was thrown, this was the stack:
#0      PlatformAssetBundle.loadBuffer (package:flutter/src/services/asset_bundle.dart:373:7)
<asynchronous suspension>
#1      AssetBundleImageProvider._loadAsync (package:flutter/src/painting/image_provider.dart:783:16)
<asynchronous suspension>
#2      MultiFrameImageStreamCompleter._handleCodecReady (package:flutter/src/painting/image_stream.dart:1021:3)
<asynchronous suspension>

Image provider: AssetImage(bundle: null, name: "assets/images/compass_dial.png")
Image key: AssetBundleImageKey(bundle: PlatformAssetBundle#564ab(), name:
  "assets/images/compass_dial.png", scale: 1.0)
════════════════════════════════════════════════════════════════════════════════════════════════════

D/EGL_emulation( 5187): app_time_stats: avg=166.90ms min=13.01ms max=770.35ms count=6
D/EGL_emulation( 5187): app_time_stats: avg=51.68ms min=8.32ms max=248.49ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.81ms min=12.28ms max=71.38ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=53.12ms min=19.59ms max=79.50ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=51.74ms min=9.89ms max=68.39ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=53.39ms min=18.41ms max=68.25ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=53.38ms min=12.59ms max=75.90ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=46.03ms min=6.39ms max=72.51ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.50ms min=6.95ms max=71.17ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.88ms min=7.64ms max=68.65ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=52.27ms min=21.42ms max=69.77ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.94ms min=14.31ms max=69.27ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.61ms min=7.02ms max=70.57ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=52.48ms min=7.68ms max=101.83ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=49.90ms min=12.90ms max=68.77ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.06ms min=4.11ms max=70.42ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.44ms min=4.06ms max=69.41ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=46.51ms min=6.08ms max=85.67ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.12ms min=13.74ms max=68.61ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.84ms min=11.89ms max=67.47ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=52.54ms min=15.11ms max=69.45ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.75ms min=4.55ms max=69.01ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.92ms min=12.17ms max=69.14ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.88ms min=4.92ms max=67.61ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.80ms min=15.58ms max=68.22ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.94ms min=14.31ms max=69.55ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.95ms min=13.13ms max=68.71ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=51.65ms min=14.10ms max=73.02ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=46.79ms min=7.02ms max=84.10ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=46.24ms min=11.00ms max=73.46ms count=22
D/EGL_emulation( 5187): app_time_stats: avg=50.66ms min=14.62ms max=68.15ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.58ms min=13.27ms max=68.90ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.90ms min=6.23ms max=67.24ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.35ms min=11.62ms max=67.97ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=46.20ms min=13.26ms max=70.48ms count=22
D/EGL_emulation( 5187): app_time_stats: avg=48.34ms min=12.38ms max=68.97ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.15ms min=14.14ms max=69.36ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.21ms min=14.91ms max=67.43ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.59ms min=13.38ms max=83.30ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.10ms min=14.66ms max=67.27ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=51.67ms min=13.89ms max=69.84ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=53.42ms min=13.15ms max=71.68ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=49.96ms min=12.58ms max=68.37ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.37ms min=12.18ms max=68.00ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.87ms min=12.89ms max=69.61ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.72ms min=12.56ms max=68.39ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.50ms min=5.50ms max=67.58ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=52.45ms min=12.59ms max=72.78ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.68ms min=4.63ms max=68.96ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.79ms min=13.39ms max=67.34ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.89ms min=3.76ms max=74.57ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.73ms min=12.40ms max=83.38ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.13ms min=12.27ms max=66.63ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=52.48ms min=12.54ms max=73.26ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.78ms min=12.54ms max=67.73ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.77ms min=13.09ms max=67.54ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=54.33ms min=11.87ms max=84.71ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=49.93ms min=12.35ms max=68.70ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.58ms min=5.07ms max=68.14ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.72ms min=11.08ms max=67.60ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.12ms min=11.64ms max=85.52ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.84ms min=13.51ms max=69.10ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=52.46ms min=13.54ms max=67.78ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.79ms min=14.62ms max=69.20ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.91ms min=12.23ms max=67.84ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.78ms min=14.83ms max=67.73ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=54.39ms min=11.46ms max=89.44ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=48.36ms min=3.70ms max=82.86ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.80ms min=13.27ms max=69.49ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.49ms min=13.75ms max=68.39ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.07ms min=14.31ms max=68.14ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.22ms min=11.90ms max=70.33ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.05ms min=15.09ms max=68.40ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.22ms min=12.57ms max=71.85ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=52.77ms min=15.34ms max=66.86ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=48.20ms min=13.07ms max=69.79ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=47.54ms min=5.09ms max=68.18ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.33ms min=15.32ms max=72.01ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.36ms min=14.11ms max=69.60ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=52.63ms min=12.59ms max=71.79ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=50.15ms min=13.37ms max=69.84ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=47.82ms min=4.27ms max=67.44ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.23ms min=3.37ms max=67.63ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.19ms min=3.43ms max=69.09ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.80ms min=3.79ms max=68.71ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=51.00ms min=7.18ms max=68.07ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=53.43ms min=15.67ms max=84.27ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=49.93ms min=11.89ms max=68.86ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.98ms min=15.39ms max=73.39ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.35ms min=12.15ms max=71.58ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.95ms min=11.95ms max=70.15ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.81ms min=13.51ms max=69.83ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.95ms min=13.19ms max=84.00ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.71ms min=12.38ms max=67.66ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=53.47ms min=11.10ms max=71.85ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=50.84ms min=15.19ms max=71.68ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.87ms min=13.88ms max=67.84ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.96ms min=11.78ms max=72.20ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.91ms min=14.22ms max=67.72ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.08ms min=4.08ms max=83.69ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.81ms min=15.22ms max=68.11ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=47.89ms min=4.28ms max=68.54ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=46.58ms min=5.41ms max=68.77ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.39ms min=5.46ms max=67.50ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=45.65ms min=3.56ms max=67.68ms count=22
D/EGL_emulation( 5187): app_time_stats: avg=50.78ms min=12.99ms max=70.48ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=52.44ms min=12.92ms max=71.32ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.37ms min=14.33ms max=70.73ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.79ms min=12.28ms max=67.87ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.99ms min=13.56ms max=67.82ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.73ms min=13.32ms max=69.63ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.97ms min=14.12ms max=67.95ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.51ms min=6.86ms max=68.10ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.18ms min=12.54ms max=72.20ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=47.70ms min=11.62ms max=67.97ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.01ms min=14.61ms max=68.27ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=52.61ms min=14.27ms max=83.50ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=45.98ms min=12.15ms max=72.99ms count=22
D/EGL_emulation( 5187): app_time_stats: avg=48.40ms min=14.39ms max=68.18ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=48.28ms min=13.82ms max=67.67ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.08ms min=3.45ms max=70.44ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.23ms min=3.70ms max=67.99ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.94ms min=13.72ms max=68.34ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.86ms min=4.86ms max=73.68ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.30ms min=13.22ms max=68.75ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=52.60ms min=11.65ms max=67.52ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=51.50ms min=4.68ms max=73.59ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.98ms min=13.02ms max=71.85ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.31ms min=14.39ms max=68.75ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=53.24ms min=12.37ms max=83.92ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=49.09ms min=3.74ms max=69.71ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.58ms min=11.53ms max=72.31ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.98ms min=15.70ms max=68.88ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.81ms min=12.96ms max=67.72ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=49.97ms min=14.06ms max=67.86ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.71ms min=14.63ms max=67.66ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.77ms min=3.25ms max=67.93ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.88ms min=14.01ms max=83.18ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=52.34ms min=12.63ms max=72.92ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=53.47ms min=12.23ms max=88.09ms count=19
D/EGL_emulation( 5187): app_time_stats: avg=46.57ms min=4.01ms max=68.26ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.00ms min=4.65ms max=71.96ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=46.17ms min=4.17ms max=68.74ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=50.83ms min=12.78ms max=67.39ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=50.85ms min=15.00ms max=67.66ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=48.22ms min=3.87ms max=67.75ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.74ms min=14.32ms max=68.85ms count=21
D/EGL_emulation( 5187): app_time_stats: avg=49.07ms min=4.27ms max=68.26ms count=20
D/EGL_emulation( 5187): app_time_stats: avg=51.16ms min=10.34ms max=68.24ms count=20
