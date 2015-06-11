

# Objective

To stream log file data, parse types and publish it via websockets.

## Motivation

Many systems can be modelled as event streams. 
We are interested in systems which consume event streams and perform actions based on the events consumed.
For example, a Patient may record an Outcome which triggers an AlertEvent. 
An AlerEvent may trigger an AutoResponder emits a Message as yet another event.

## The Wish List
- Ability to reason about temoral events
- Ability to reason about and emit events conditionally
- Ability to easily configure event stream based DSL for arbitrary streams
- Ability to extend events in a safe manner
- Ability to learn hierarchical models from event stream

# Todos

define the events

define Snap process for streaming the log data.

define log parser and model builder

define model publishing interface for web sockets

catch published models and render in js.

# Questions

What is the structure of the log files?

What models or state are we parsing out?

What are we doing with the stream?

# Reading

http://en.wikipedia.org/wiki/Conditional_event_algebra

