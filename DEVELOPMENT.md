# Development

## Frameworks and Modifications

This tweak uses QuartzKit, however, the patched iOS
SDKs provided by theos do not include all the required
methods.

### Modifications to QuartzKit

You will need to modify the file `CALayer.h` in
`$THEOS/sdks/iPhoneOS11.2.sdk/System/Library/Frameworks/QuartzCore.framework/Headers/`
, where the folder after `sdks/` can be any sdk
you specified in your `Makefile`.

##### Modifications to CALayer.h

In the block for the `CALayer` interface, add in the following lines:

```objective-c
/** ADDED BY TAREQ FOR SUPPORT OF STATE CONTROL **/
@property(copy) NSArray *stateTransitions; //@dynamic stateTransitions;
@property(copy) NSArray *states; //@dynamic states;
-(void)insertState:(id)arg1 atIndex:(unsigned int)arg2;
```

At the end of the file, also add the following code to allow interfacing with `CAStateElement` and `CAStateSetValue`

```objective-c
/** ADDED BY TAREQ FOR INTERFACING WITH CAStateElement and CAStateSetValue **/

@interface CAStateElement : NSObject <NSCopying, NSSecureCoding> {
    CAStateElement * _source;
    CALayer * _target;
}

@property (nonatomic, readonly, copy) NSString *keyPath;
@property (nonatomic, retain) CAStateElement *source;
@property (nonatomic) CALayer *target;

+ (void)CAMLParserStartElement:(id)arg1;
+ (bool)supportsSecureCoding;

// - (void).cxx_destruct;
- (void)CAMLParser:(id)arg1 setValue:(id)arg2 forKey:(id)arg3;
- (id)CAMLTypeForKey:(id)arg1;
- (void)apply:(id)arg1;
- (id)copyWithZone:(struct _NSZone { }*)arg1;
- (void)dealloc;
- (void)encodeWithCAMLWriter:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (void)foreachLayer:(id /* block */)arg1;
- (id)initWithCoder:(id)arg1;
- (id)keyPath;
- (bool)matches:(id)arg1;
- (id)save;
- (void)setSource:(id)arg1;
- (void)setTarget:(id)arg1;
- (id)source;
- (id)target;
- (id)targetName;

@end

@interface CAStateSetValue : CAStateElement {
    NSString * _keyPath;
    id  _value;
}

@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, retain) id value;

+ (bool)supportsSecureCoding;

- (id)CAMLTypeForKey:(id)arg1;
- (void)apply:(id)arg1;
- (id)copyWithZone:(struct _NSZone { }*)arg1;
- (void)dealloc;
- (id)debugDescription;
- (void)encodeWithCAMLWriter:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (void)foreachLayer:(id /* block */)arg1;
- (id)initWithCoder:(id)arg1;
- (id)keyPath;
- (bool)matches:(id)arg1;
- (void)setKeyPath:(id)arg1;
- (void)setValue:(id)arg1;
- (id)value;

@end
```

See [frameworks/CALayer.h](frameworks/CALayer.h) for
details on how the modifications for CALayer.h might
look like. You can copy paste the file if you haven't
modified the framework before.
