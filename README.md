# Rust WebAssembly Development Seed w/ K3S and Krustlet

This application seed helps you get started quickly in minutes developing Rust based WebAssembly applications
that can be deployed on K3S based devices w/ Krustlet.

## Walkthrough

This walkthrough will take you, over the course of 5 minutes, from nothing to a complete Rust WebAssembly development environment including a K3S cluster w/ Krustlet preconfigured for near loop development.

Let's go!

1. Launch a codespace on this repo by pressing the Code button above and then "New codespace."

1. This starts a codespace that contains all of the required dependencies you need to develop your first WebAssembly application and deploy it to the local K3s cluster.

1. Once the codespace container has been build and launched, the codespace IDE will launch. Behind the scenes, we are launching K3S and then connecting a Krustlet node to it. Switch to the bash tab on the right - the "GitHub Codespaces: Configuration" tab will remain open as it hosts Krustlet.

1. Once the IDE is ready, you are ready to start your inner dev loop. Let's run the application in the shell to see what it does. Hit F1, then select 'Tasks: Run Task', and then select 'Run'. You should see something that looks like this:

```bash
  Downloaded 6 crates (805.7 KB) in 0.28s
   Compiling autocfg v1.0.1
   Compiling libc v0.2.103
   Compiling num-traits v0.2.14
   Compiling num-integer v0.1.44
   Compiling time v0.1.44
   Compiling chrono v0.4.19
   Compiling hello-world-rust v0.1.0 (/workspaces/krustlet-seed)
    Finished dev [unoptimized + debuginfo] target(s) in 28.16s
     Running `target/debug/hello-world-rust`
hello world @ 17:00:25
hello world @ 17:00:26
hello world @ 17:00:27
hello world @ 17:00:28
...
```

Hit Ctrl-C to exit and stop.

5. So inner loop is easy, but we are here to do harder things, but first let's first confirm that the Krustlet node has started:

```bash
@timfpark ➜ /workspaces/krustlet-seed (main) $ kubectl get nodes
NAME                       STATUS   ROLES                  AGE   VERSION
k3d-k3s-default-server-0   Ready    control-plane,master   75s   v1.21.3+k3s1
krustlet                   Ready    <none>                 16s   1.0.0-alpha.1
```

If you don't see krustlet in the list, get a cup of coffee and try again.

6.  With our Krustlet node up, let's deploy our current code in the cluster on a Krustlet node. Hit F1, select 'Tasks: Run Task', and then select "Run in local cluster". This will build with a `wasm32-wasi` target, push the WASM to our local OCI container registry, and then do a deployment of this to our locally running cluster.

You should see something like this:

```
> Executing task: .devcontainer/run.sh <

    Finished release [optimized] target(s) in 0.01s

INFO[0000] Pushed: localhost:12345/hello-world-rust:20211008T173352Z
INFO[0000] Size: 1908051
INFO[0000] Digest: sha256:af721968b8166fcbb6ff66cc6df1fd2c13e4300ab5010b3650ec25e947b219e8
hello-world-wasi-rust 0/1 1 0 28m
deployment.apps "hello-world-wasi-rust" deleted
deployment.apps/hello-world-wasi-rust created
Build deployed

Terminal will be reused by tasks, press any key to close it.
```

Go ahead and press any key to close the Terminal and go back to your bash shell. You should be able to see the WebAssembly pod running:

```bash
@timfpark ➜ /workspaces/krustlet-seed (main) $ kubectl get pods -o wide
NAME                                     READY   STATUS    RESTARTS   AGE     IP       NODE       NOMINATED NODE   READINESS GATES
hello-world-wasi-rust-7b54f7ddcf-52zvd   1/1     Running   0          2m13s   <none>   krustlet   <none>           <none>
```

Notice that it is running on the krustlet node, which we targeted by adding [tolerations to our deployment](deploy/codespace.yaml).

Finally, we can see that it is running correctly by looking at its logs:

```bash
@timfpark ➜ /workspaces/krustlet-seed (main) $ kubectl logs hello-world-wasi-rust-7b54f7ddcf-52zvd
hello world @ 17:33:55
hello world @ 17:33:56
hello world @ 17:33:57
hello world @ 17:33:58
hello world @ 17:33:59
...
```

So we have, in the course of a couple of minutes (and with zero fiddly configuration), created a codespace, built an application, run it locally, and deployed it to a Krustlet node in our K3S cluster. We can make [changes to our application](src/main.rs), follow the last step again, and see those changes running in our local cluster. Finally, this local development cluster is nearly identical to our production deployment architecture, so we have a lot of confidence that our builds will work there.
