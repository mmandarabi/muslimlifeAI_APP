PS D:\solutions\MuslimLifeAI_demo> flutter clean                
Deleting build...                                                  13.9s
Deleting .dart_tool...                                             122ms
Deleting ephemeral...                                               24ms
Deleting Generated.xcconfig...                                      10ms
Deleting flutter_export_environment.sh...                            0ms
Deleting ephemeral...                                               12ms
Deleting ephemeral...                                                1ms
Deleting ephemeral...                                                3ms
Deleting .flutter-plugins-dependencies...                            0ms
PS D:\solutions\MuslimLifeAI_demo> flutter run -d emulator-5554 
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
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 43 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\android_alarm_manager_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more

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
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 43 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\flutter_timezone\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more

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
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 43 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\package_info_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more

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
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 43 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more

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
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\class-fq-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 43 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\source-to-classes.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] is already registered
                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
                Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin\internal-name-to-source.tab] registration stack trace
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                        ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\id-to-file.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups\file-to-id.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more
        Suppressed: java.lang.Exception: Could not close incremental caches in D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalStateException: Storage for [D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] is already registered
                        at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:410)
                        at org.jetbrains.kotlin.com.intellij.util.io.PagedFileStorage.<init>(PagedFileStorage.java:72)
                        at org.jetbrains.kotlin.com.intellij.util.io.ResizeableMappedFile.<init>(ResizeableMappedFile.java:68)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentBTreeEnumerator.<init>(PersistentBTreeEnumerator.java:128)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentEnumerator.createDefaultEnumerator(PersistentEnumerator.java:52)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:165)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.<init>(PersistentMapImpl.java:140)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.buildImplementation(PersistentMapBuilder.java:88)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapBuilder.build(PersistentMapBuilder.java:71)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:46)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.<init>(PersistentHashMap.java:72)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.createMap(LazyStorage.kt:62)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.getStorageOrCreateNew(LazyStorage.kt:59)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more
                        Suppressed: java.lang.Exception: Storage[D:\solutions\MuslimLifeAI_demo\build\wakelock_plus\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs\source-to-output.tab] registration stack trace
                                at org.jetbrains.kotlin.com.intellij.util.io.FilePageCache.registerPagedFileStorage(FilePageCache.java:437)
                                ... 44 more

Running Gradle task 'assembleDebug'...                            116.4s
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...           4.8s
D/FlutterJNI(17339): Beginning load of flutter...
D/FlutterJNI(17339): flutter (null) was loaded normally!
I/flutter (17339): [IMPORTANT:flutter/shell/platform/android/android_context_gl_impeller.cc(104)] Using the Impeller rendering backend (OpenGLES).
D/FlutterGeolocator(17339): Attaching Geolocator to activity
I/Choreographer(17339): Skipped 199 frames!  The application may be doing too much work on its main thread.
D/HostConnection(17339): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 
W/OpenGLRenderer(17339): Failed to choose config with EGL_SWAP_BEHAVIOR_PRESERVED, retrying without...
W/OpenGLRenderer(17339): Failed to initialize 101010-2 format, error = EGL_SUCCESS
I/Gralloc4(17339): mapper 4.x is not supported
D/EGL_emulation(17339): eglCreateContext: 0x78ada91ba410: maj 3 min 1 rcv 4
D/EGL_emulation(17339): eglMakeCurrent: 0x78ada91ba410: ver 3 1 (tinfo 0x78afc7b3c180) (first time)
W/Gralloc4(17339): allocator 4.x is not supported
D/HostConnection(17339): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 
E/OpenGLRenderer(17339): Unable to match the desired swap behavior.
D/FlutterGeolocator(17339): Creating service.
D/FlutterGeolocator(17339): Binding to location service.
I/Choreographer(17339): Skipped 68 frames!  The application may be doing too much work on its main thread.
D/FlutterGeolocator(17339): Geolocator foreground service connected
D/FlutterGeolocator(17339): Initializing Geolocator services
D/FlutterGeolocator(17339): Flutter engine connected. Connected engine count 1
I/FlutterBackgroundExecutor(17339): Starting AlarmService...
I/AndroidAlarmManagerPlugin(17339): onAttachedToEngine
D/HostConnection(17339): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 
D/EGL_emulation(17339): eglCreateContext: 0x78ada91b7050: maj 3 min 1 rcv 4
D/EGL_emulation(17339): eglCreateContext: 0x78ada91b9b10: maj 3 min 1 rcv 4
D/EGL_emulation(17339): eglMakeCurrent: 0x78ada91b9b10: ver 3 1 (tinfo 0x78afc7b3c200) (first time)
I/flutter (17339): [IMPORTANT:flutter/shell/platform/android/android_context_gl_impeller.cc(104)] Using the Impeller rendering backend (OpenGLES).
Syncing files to device sdk gphone64 x86 64...                     344ms

Flutter run key commands.
r Hot reload. 
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on sdk gphone64 x86 64 is available at: http://127.0.0.1:62805/bHtCFUNqqzM=/
The Flutter DevTools debugger and profiler on sdk gphone64 x86 64 is available at: http://127.0.0.1:62805/bHtCFUNqqzM=/devtools/?uri=ws://127.0.0.1:62805/bHtCFUNqqzM=/ws
D/HostConnection(17339): HostComposition ext ANDROID_EMU_CHECKSUM_HELPER_v1 ANDROID_EMU_native_sync_v2 ANDROID_EMU_native_sync_v3 ANDROID_EMU_native_sync_v4 ANDROID_EMU_dma_v1 ANDROID_EMU_direct_mem ANDROID_EMU_host_composition_v1 ANDROID_EMU_host_composition_v2 ANDROID_EMU_vulkan ANDROID_EMU_deferred_vulkan_commands ANDROID_EMU_vulkan_null_optional_strings ANDROID_EMU_vulkan_create_resources_with_requirements ANDROID_EMU_YUV_Cache ANDROID_EMU_vulkan_ignored_handles ANDROID_EMU_has_shared_slots_host_memory_allocator ANDROID_EMU_vulkan_free_memory_sync ANDROID_EMU_vulkan_shader_float16_int8 ANDROID_EMU_vulkan_async_queue_submit ANDROID_EMU_vulkan_queue_submit_with_commands ANDROID_EMU_sync_buffer_data ANDROID_EMU_vulkan_async_qsri ANDROID_EMU_read_color_buffer_dma ANDROID_EMU_hwc_multi_configs ANDROID_EMU_hwc_color_transform GL_OES_EGL_image_external_essl3 GL_OES_vertex_array_object GL_KHR_texture_compression_astc_ldr ANDROID_EMU_host_side_tracing ANDROID_EMU_gles_max_version_3_1 
D/EGL_emulation(17339): eglMakeCurrent: 0x78ada91b9b10: ver 3 1 (tinfo 0x78afc7b3c280) (first time)
I/Choreographer(17339): Skipped 68 frames!  The application may be doing too much work on its main thread.
D/FlutterGeolocator(17339): Geolocator foreground service connected
D/FlutterGeolocator(17339): Initializing Geolocator services
D/FlutterGeolocator(17339): Flutter engine connected. Connected engine count 2
I/flutter (17339): UnifiedAudioService: AndroidAlarmManager initialized.
I/AlarmService(17339): AlarmService started!
I/flutter (17339): Firebase already initialized
I/flutter (17339): Firebase Emulator connection is currently disabled. Connecting to LIVE Firebase.
I/flutter (17339): Auth State Chain: ConnectionState.waiting | HasData: false | Error: null
I/flutter (17339): ExpandableAudioPlayer: Build. Surah: NULL
I/flutter (17339): Auth State Chain: ConnectionState.active | HasData: true | Error: null
I/flutter (17339): User detected: MnNcvOKRSkOiXmgIfFmNMRnbNWB3
I/flutter (17339): PrayerService: Fetching prayer times...
I/flutter (17339): PrayerService: Loaded offline data from disk.
I/flutter (17339): PrayerService: Loaded offline data from disk.
I/flutter (17339): PrayerService: Loaded offline data from disk.
I/flutter (17339): PrayerService: Fetching prayer times...
I/Choreographer(17339): Skipped 173 frames!  The application may be doing too much work on its main thread.
D/ProfileInstaller(17339): Installing profile for ai.muslimlife.app
I/Choreographer(17339): Skipped 70 frames!  The application may be doing too much work on its main thread.
I/OpenGLRenderer(17339): Davey! duration=1287ms; Flags=1, FrameTimelineVsyncId=21013970, IntendedVsync=46074531741166, Vsync=46075698407786, InputEventId=0, HandleInputStart=46075712483800, AnimationStart=46075712507700, PerformTraversalsStart=46075712540100, DrawStart=46075728580200, FrameDeadline=46074548407832, FrameInterval=46075710940400, FrameStartTime=16666666, SyncQueued=46075731184200, SyncStart=46075732874600, IssueDrawCommandsStart=46075733093800, SwapBuffers=46075789627400, FrameCompleted=46075821251200, DequeueBufferDuration=27942400, QueueBufferDuration=222900, GpuCompleted=46075800525000, SwapBuffersCompleted=46075821251200, DisplayPresentTime=0, CommandSubmissionCompleted=46075789627400, 
D/EGL_emulation(17339): app_time_stats: avg=919.14ms min=573.95ms max=1311.95ms count=3
I/flutter (17339): QiblaScreen: Fetching last known position...
I/flutter (17339): QiblaScreen: Requesting current position (45s limit)...
D/EGL_emulation(17339): app_time_stats: avg=142.08ms min=21.29ms max=344.35ms count=7
D/EGL_emulation(17339): app_time_stats: avg=77.56ms min=17.02ms max=477.89ms count=13
D/EGL_emulation(17339): app_time_stats: avg=81.02ms min=17.29ms max=718.48ms count=20
D/EGL_emulation(17339): app_time_stats: avg=111.54ms min=63.49ms max=234.53ms count=9
D/EGL_emulation(17339): app_time_stats: avg=95.85ms min=49.22ms max=156.62ms count=11
D/EGL_emulation(17339): app_time_stats: avg=58.07ms min=44.44ms max=81.69ms count=18
D/EGL_emulation(17339): app_time_stats: avg=41.12ms min=15.11ms max=60.55ms count=24
I/flutter (17339): TRACE: UnifiedAudioService.stop() called. Current Session: 0
I/flutter (17339): ExpandableAudioPlayer: Build. Surah: Al-Ikhlas
I/flutter (17339): ════════════════════════════════════════
I/flutter (17339): LAYOUT DATABASE VERIFICATION
I/flutter (17339): ════════════════════════════════════════
I/flutter (17339): 📖 Page 604 (Multi-Surah):
I/flutter (17339): UnifiedAudioService: Loaded timestamps for Surah 112 from disk.
W/OnBackInvokedCallback(17339): OnBackInvokedCallback is not enabled for the application.
W/OnBackInvokedCallback(17339): Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.
D/EGL_emulation(17339): app_time_stats: avg=4870.70ms min=92.70ms max=9648.69ms count=2
I/flutter (17339): Opening existing ayahinfo.db
I/flutter (17339): Opening existing ayahinfo.db
I/flutter (17339):   Line 1: surah_name   surah=112
I/flutter (17339):   Line 2: basmallah    surah=-
I/flutter (17339):   Line 3: ayah         surah=-
I/flutter (17339):   Line 4: ayah         surah=-
I/flutter (17339):   Line 5: surah_name   surah=113
I/flutter (17339):   Line 6: basmallah    surah=-
I/flutter (17339):   Line 7: ayah         surah=-
I/flutter (17339):   Line 8: ayah         surah=-
I/flutter (17339):   Line 9: ayah         surah=-
I/flutter (17339):   Line 10: surah_name   surah=114
I/flutter (17339):   Line 11: basmallah    surah=-
I/flutter (17339):   Line 12: ayah         surah=-
I/flutter (17339):   Line 13: ayah         surah=-
I/flutter (17339):   Line 14: ayah         surah=-
I/flutter (17339):   Line 15: ayah         surah=-
I/flutter (17339): 📖 Page 1 (Al-Fatiha):
I/flutter (17339):   Line 1: surah_name surah=1
I/flutter (17339): 📖 Page 187 (At-Tawbah):
I/flutter (17339):   Line 1: surah_name surah=9
I/flutter (17339): ════════════════════════════════════════
I/flutter (17339): VERIFICATION COMPLETE
I/flutter (17339): ════════════════════════════════════════
D/EGL_emulation(17339): app_time_stats: avg=48.17ms min=13.15ms max=179.51ms count=20
I/flutter (17339): ✅ MushafTextService initialized. Loaded 604 pages.
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): UI Line 1 (surah_name): HEADER/BISMILLAH
I/flutter (17339): LINE 1 DEBUG:
I/flutter (17339):   lineType: surah_name
I/flutter (17339):   surahNumber: 112
I/flutter (17339):   Widget: HEADER
I/flutter (17339): UI Line 2 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 3 (ayah): textLines[0] = ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): UI Line 4 (ayah): textLines[1] = ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339): UI Line 5 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 6 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 7 (ayah): textLines[2] = ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): UI Line 8 (ayah): textLines[3] = ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339): UI Line 9 (ayah): textLines[4] = ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): UI Line 10 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 11 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 12 (ayah): textLines[5] = ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): UI Line 13 (ayah): textLines[6] = ﱵ ﱶ ﱷ...
I/flutter (17339): UI Line 14 (ayah): textLines[7] = ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): UI Line 15 (ayah): textLines[8] = ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): UI Line 1 (surah_name): HEADER/BISMILLAH
I/flutter (17339): LINE 1 DEBUG:
I/flutter (17339):   lineType: surah_name
I/flutter (17339):   surahNumber: 112
I/flutter (17339):   Widget: HEADER
I/flutter (17339): UI Line 2 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 3 (ayah): textLines[0] = ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): UI Line 4 (ayah): textLines[1] = ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339): UI Line 5 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 6 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 7 (ayah): textLines[2] = ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): UI Line 8 (ayah): textLines[3] = ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339): UI Line 9 (ayah): textLines[4] = ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): UI Line 10 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 11 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 12 (ayah): textLines[5] = ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): UI Line 13 (ayah): textLines[6] = ﱵ ﱶ ﱷ...
I/flutter (17339): UI Line 14 (ayah): textLines[7] = ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): UI Line 15 (ayah): textLines[8] = ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
D/EGL_emulation(17339): app_time_stats: avg=298.65ms min=54.75ms max=518.00ms count=4
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): UI Line 1 (surah_name): HEADER/BISMILLAH
I/flutter (17339): LINE 1 DEBUG:
I/flutter (17339):   lineType: surah_name
I/flutter (17339):   surahNumber: 112
I/flutter (17339):   Widget: HEADER
I/flutter (17339): UI Line 2 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 3 (ayah): textLines[0] = ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): UI Line 4 (ayah): textLines[1] = ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339): UI Line 5 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 6 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 7 (ayah): textLines[2] = ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): UI Line 8 (ayah): textLines[3] = ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339): UI Line 9 (ayah): textLines[4] = ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): UI Line 10 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 11 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 12 (ayah): textLines[5] = ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): UI Line 13 (ayah): textLines[6] = ﱵ ﱶ ﱷ...
I/flutter (17339): UI Line 14 (ayah): textLines[7] = ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): UI Line 15 (ayah): textLines[8] = ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): === MERGE DEBUG (Page 604) ===
I/flutter (17339): Before merge: 15 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   [2]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   [5]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   [10]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [13, 14]:
I/flutter (17339):   [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ...
I/flutter (17339):   [14]: ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339):   Result at [13]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): Merging indices [11, 12]:
I/flutter (17339):   [11]: ﱸ ﱹ ﱺ...
I/flutter (17339):   [12]: ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   Result at [11]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): Merging indices [8, 9]:
I/flutter (17339):   [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ...
I/flutter (17339):   [9]: ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339):   Result at [8]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): Merging indices [6, 7]:
I/flutter (17339):   [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ...
I/flutter (17339):   [7]: ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339):   Result at [6]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): Merging indices [3, 4]:
I/flutter (17339):   [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ...
I/flutter (17339):   [4]: ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339):   Result at [3]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): Merging indices [0, 1]:
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ...
I/flutter (17339):   [1]: ﱆ ﱇ ﱈ...
I/flutter (17339):   Result at [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): After merge: 9 lines
I/flutter (17339):   [0]: ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339):   [1]: ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339):   [2]: ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ...
I/flutter (17339):   [3]: ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339):   [4]: ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ...
I/flutter (17339):   [5]: ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ...
I/flutter (17339):   [6]: ﱵ ﱶ ﱷ...
I/flutter (17339):   [7]: ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339):   [8]: ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): ===========================
I/flutter (17339): UI Line 1 (surah_name): HEADER/BISMILLAH
I/flutter (17339): LINE 1 DEBUG:
I/flutter (17339):   lineType: surah_name
I/flutter (17339):   surahNumber: 112
I/flutter (17339):   Widget: HEADER
I/flutter (17339): UI Line 2 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 3 (ayah): textLines[0] = ﱁ ﱂ ﱃ ﱄ ﱅ ﱆ ﱇ ﱈ...
I/flutter (17339): UI Line 4 (ayah): textLines[1] = ﱉ ﱊ ﱋ ﱌ ﱍ...
I/flutter (17339): UI Line 5 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 6 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 7 (ayah): textLines[2] = ﱎ ﱏ ﱐ ﱑ ﱒ ﱓ ﱔ ﱕ ﱖ ﱗ ﱘ...
I/flutter (17339): UI Line 8 (ayah): textLines[3] = ﱙ ﱚ ﱛ ﱜ ﱝ...
I/flutter (17339): UI Line 9 (ayah): textLines[4] = ﱞ ﱟ ﱠ ﱡ ﱢ ﱣ ﱤ ﱥ ﱦ ﱧ ﱨ ﱩ...
I/flutter (17339): UI Line 10 (surah_name): HEADER/BISMILLAH
I/flutter (17339): UI Line 11 (basmallah): HEADER/BISMILLAH
I/flutter (17339): UI Line 12 (ayah): textLines[5] = ﱪ ﱫ ﱬ ﱭ ﱮ ﱯ ﱰ ﱱ ﱲ ﱳ ﱴ...
I/flutter (17339): UI Line 13 (ayah): textLines[6] = ﱵ ﱶ ﱷ...
I/flutter (17339): UI Line 14 (ayah): textLines[7] = ﱸ ﱹ ﱺ ﱻ ﱼ ﱽ ﱾ ﱿ...
I/flutter (17339): UI Line 15 (ayah): textLines[8] = ﲀ ﲁ ﲂ ﲃ ﲄ ﲅ ﲆ ﲇ ﲈ ﲉ...
I/flutter (17339): TRACE: UnifiedAudioService.stop() called. Current Session: 1
I/flutter (17339): PrayerService: Using coordinates: null, null (Location Unavailable)
I/flutter (17339): PrayerService: Calling API: https://us-central1-muslimlifeai-fcb93.cloudfunctions.net/getPrayerTimes?lat=38.9072&lon=-77.0369&method=2
I/flutter (17339): PrayerService: Using coordinates: null, null (Location Unavailable)
I/flutter (17339): PrayerService: Calling API: https://us-central1-muslimlifeai-fcb93.cloudfunctions.net/getPrayerTimes?lat=38.9072&lon=-77.0369&method=2
I/flutter (17339): ExpandableAudioPlayer: Build. Surah: NULL