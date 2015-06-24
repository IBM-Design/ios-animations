# IBM iOS Animation
- [Code License][code-license]
- [Getting Started][getting-started]
- [Requirements][reqs]
- [Installation][install]
- [Find your way around][navigate]
- [Example][example]
- [Library][lib]
- [Use in your own project][use]

As you pull the code from this repository, get inspired by the IBM Design Language animation guidelines. Remember: thoughtfully applied animation should be straightforward, limited to the most important interactions on the screen and helping users in delightful ways as they interact.

&mdash; [IBM Design Language: Animation][animation]

This repository serves as a **codebase for developers** who want to use, prototype with, or get inspired by the machine motion style from the IBM Design Language. It contains **six unique examples**, each demonstrating the movement of a single component. The **source code and full working example** for each component are available.

## Code License
[Apache License 2.0][apache]

## Getting Started

### Requirements
- Xcode version 6.3.2
- Mac OS X 10.10 or later

### Installation
```sh
git clone https://github.com/IBM-Design/ios-animations.git
```
## Find your way around
Source files for each example can be found in their respective folder in the `Animation` folder in Project Navigator within Xcode. Each example contains a `.storyboard` and `.swift` files.

The `.storyboard` file at the top contains the visual aspect of the component. The `.swift` file below the storyboard is the view controller for the page that displays the component. The `.swift` file below the view controller for the page is the view controller for the component.

### Example

The files for the Modal component can be found here:
```
Animation
|__ Modal/
   |__ Modal.storyboard
   |__ ModalExampleViewController.swift
   |__ ModalViewController.swift
   |__ ModalAppearTransitioning.swift
   |__ ModalDismissTransitioning.swift
   |__ ModalTransitioningDelegate.swift
```

`ModalExampleViewController.swift` is the view controller for the page that displays the Modal. `ModalViewController.swift` is the view controller for the actual Modal.


# Use in your own project

Do you need Search functionality in your project? See how the example works within the `Search` folder. `TabBar`? Check out the TabBar folder. All example components are in their respective folders. Make sure to follow the requirement set forth by our license.

[code-license]: #code-license
[getting-started]: #getting-started
[reqs]: #requirements
[install]: #installation
[navigate]: #find-your-way-around
[example]: #example
[lib]: #library
[use]: #use-in-your-own-project
[animation]: http://www.ibm.com/design/language/framework/animation/introduction
[apache]: http://www.apache.org/licenses/LICENSE-2.0
