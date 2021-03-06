import Foundation

/**
    Adds methods to World to support top-level DSL functions (Swift) and
    macros (Objective-C). These functions map directly to the DSL that test
    writers use in their specs.
*/
extension World {
#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func beforeSuite(_ closure: @escaping BeforeSuiteClosure) {
        suiteHooks.appendBefore(closure)
    }
#else
    internal func beforeSuite(_ closure: @escaping BeforeSuiteClosure) {
        suiteHooks.appendBefore(closure)
    }
#endif

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func afterSuite(_ closure: @escaping AfterSuiteClosure) {
        suiteHooks.appendAfter(closure)
    }
#else
    internal func afterSuite(_ closure: @escaping AfterSuiteClosure) {
        suiteHooks.appendAfter(closure)
    }
#endif

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func sharedExamples(_ name: String, closure: @escaping SharedExampleClosure) {
        registerSharedExample(name, closure: closure)
    }
#else
    internal func sharedExamples(_ name: String, closure: @escaping SharedExampleClosure) {
        registerSharedExample(name, closure: closure)
    }
#endif

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func describe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _describe(description, flags: flags, closure: closure)
    }
#else
    internal func describe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _describe(description, flags: flags, closure: closure)
    }
#endif
    private func _describe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        guard currentExampleMetadata == nil else {
            raiseError("'describe' cannot be used inside '\(currentPhase)', 'describe' may only be used inside 'context' or 'describe'. ")
        }
        guard currentExampleGroup != nil else {
            raiseError("Error: example group was not created by its parent QuickSpec spec. Check that describe() or context() was used in QuickSpec.spec() and not a more general context (i.e. an XCTestCase test)")
        }
        let group = ExampleGroup(description: description, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group, closure: closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func context(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _context(description, flags: flags, closure: closure)
    }
#else
    internal func context(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _context(description, flags: flags, closure: closure)
    }
#endif
    private func _context(_ description: String, flags: FilterFlags, closure: () -> Void) {
        guard currentExampleMetadata == nil else {
            raiseError("'context' cannot be used inside '\(currentPhase)', 'context' may only be used inside 'context' or 'describe'. ")
        }
        self.describe(description, flags: flags, closure: closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func fdescribe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _fdescribe(description, flags: flags, closure: closure)
    }
#else
    internal func fdescribe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _fdescribe(description, flags: flags, closure: closure)
    }
#endif
    private func _fdescribe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.describe(description, flags: focusedFlags, closure: closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func xdescribe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _xdescribe(description, flags: flags, closure: closure)
    }
#else
    internal func xdescribe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        _xdescribe(description, flags: flags, closure: closure)
    }
#endif
    private func _xdescribe(_ description: String, flags: FilterFlags, closure: () -> Void) {
        var pendingFlags = flags
        pendingFlags[Filter.pending] = true
        self.describe(description, flags: pendingFlags, closure: closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func beforeEach(_ closure: @escaping BeforeExampleClosure) {
        _beforeEach(closure)
    }
#else
    internal func beforeEach(_ closure: @escaping BeforeExampleClosure) {
        _beforeEach(closure)
    }
#endif
    private func _beforeEach(_ closure: @escaping BeforeExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'beforeEach' cannot be used inside '\(currentPhase)', 'beforeEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendBefore(closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc(beforeEachWithMetadata:)
    internal func beforeEach(closure: @escaping BeforeExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }
#else
    internal func beforeEach(closure: @escaping BeforeExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }
#endif

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func afterEach(_ closure: @escaping AfterExampleClosure) {
        _afterEach(closure)
    }
#else
    internal func afterEach(_ closure: @escaping AfterExampleClosure) {
        _afterEach(closure)
    }
#endif
    private func _afterEach(_ closure: @escaping AfterExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'afterEach' cannot be used inside '\(currentPhase)', 'afterEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendAfter(closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc(afterEachWithMetadata:)
    internal func afterEach(closure: @escaping AfterExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }
#else
    internal func afterEach(closure: @escaping AfterExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }
#endif

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func it(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        _it(description, flags: flags, file: file, line: line, closure: closure)
    }
#else
    internal func it(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        _it(description, flags: flags, file: file, line: line, closure: closure)
    }
#endif
    private func _it(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        if beforesCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'beforeEach', 'it' may only be used inside 'context' or 'describe'. ")
        }
        if aftersCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'afterEach', 'it' may only be used inside 'context' or 'describe'. ")
        }
        guard currentExampleMetadata == nil else {
            raiseError("'it' cannot be used inside 'it', 'it' may only be used inside 'context' or 'describe'. ")
        }
        let callsite = Callsite(file: file, line: line)
        let example = Example(description: description, callsite: callsite, flags: flags, closure: closure)
        currentExampleGroup.appendExample(example)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func fit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        _fit(description, flags: flags, file: file, line: line, closure: closure)
    }
#else
    internal func fit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        _fit(description, flags: flags, file: file, line: line, closure: closure)
    }
#endif
    private func _fit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.it(description, flags: focusedFlags, file: file, line: line, closure: closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func xit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        _xit(description, flags: flags, file: file, line: line, closure: closure)
    }
#else
    internal func xit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        _xit(description, flags: flags, file: file, line: line, closure: closure)
    }
#endif
    private func _xit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        var pendingFlags = flags
        pendingFlags[Filter.pending] = true
        self.it(description, flags: pendingFlags, file: file, line: line, closure: closure)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func itBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        _itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
    }
#else
    internal func itBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        _itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
    }
#endif
    private func _itBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        guard currentExampleMetadata == nil else {
            raiseError("'itBehavesLike' cannot be used inside '\(currentPhase)', 'itBehavesLike' may only be used inside 'context' or 'describe'. ")
        }
        let callsite = Callsite(file: file, line: line)
        let closure = World.sharedWorld.sharedExample(name)

        let group = ExampleGroup(description: name, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group) {
            closure(sharedExampleContext)
        }

        group.walkDownExamples { (example: Example) in
            example.isSharedExample = true
            example.callsite = callsite
        }
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func fitBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        _fitBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
    }
#else
    internal func fitBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        _fitBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
    }
#endif
    private func _fitBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: focusedFlags, file: file, line: line)
    }

    internal func itBehavesLike<C>(_ behavior: Behavior<C>.Type, context: @escaping () -> C, flags: FilterFlags, file: String, line: UInt) {
        guard currentExampleMetadata == nil else {
            raiseError("'itBehavesLike' cannot be used inside '\(currentPhase)', 'itBehavesLike' may only be used inside 'context' or 'describe'. ")
        }
        let callsite = Callsite(file: file, line: line)
        let closure = behavior.spec
        let group = ExampleGroup(description: behavior.name, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        performWithCurrentExampleGroup(group) {
            closure(context)
        }

        group.walkDownExamples { (example: Example) in
            example.isSharedExample = true
            example.callsite = callsite
        }
    }

    internal func fitBehavesLike<C>(_ behavior: Behavior<C>.Type, context: @escaping () -> C, flags: FilterFlags, file: String, line: UInt) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.itBehavesLike(behavior, context: context, flags: focusedFlags, file: file, line: line)
    }

    internal func xitBehavesLike<C>(_ behavior: Behavior<C>.Type, context: @escaping () -> C, flags: FilterFlags, file: String, line: UInt) {
        var pendingFlags = flags
        pendingFlags[Filter.pending] = true
        self.itBehavesLike(behavior, context: context, flags: pendingFlags, file: file, line: line)
    }

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc(itWithDescription:flags:file:line:closure:)
    private func objc_it(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        it(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(fitWithDescription:flags:file:line:closure:)
    private func objc_fit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        fit(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(xitWithDescription:flags:file:line:closure:)
    private func objc_xit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: @escaping () -> Void) {
        xit(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(itBehavesLikeSharedExampleNamed:sharedExampleContext:flags:file:line:)
    private func objc_itBehavesLike(_ name: String, sharedExampleContext: @escaping SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
    }
#endif

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE
    @objc
    internal func pending(_ description: String, closure: () -> Void) {
        print("Pending: \(description)")
    }
#else
    internal func pending(_ description: String, closure: () -> Void) {
        print("Pending: \(description)")
    }
#endif

    private var currentPhase: String {
        if beforesCurrentlyExecuting {
            return "beforeEach"
        } else if aftersCurrentlyExecuting {
            return "afterEach"
        }

        return "it"
    }
}
