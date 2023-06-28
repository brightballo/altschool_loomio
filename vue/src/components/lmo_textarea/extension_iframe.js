import {
  Node,
  nodeInputRule,
  mergeAttributes,
} from '@tiptap/core'

export const inputRegex = /!\[(.+|:?)]\((\S+)(?:(?:\s+)["'](\S+)["'])?\)/

export const Iframe = Node.create({
  name: 'iframe',
  group: 'block',
  selectable: false,

  addOptions() {
    return {
      HTMLAttributes: {}
    }
  },

  addAttributes() {
    return {
      src: {
        default: null,
      },
      allowfullscreen: {
        default: true
      }
    }
  },

  parseHTML() {
    return [
      { tag: 'iframe[src]' },
    ]
  },

  renderHTML({ HTMLAttributes }) {
    return ['div', {'data-iframe-container': '1'}, ['iframe', mergeAttributes(this.options.HTMLAttributes, HTMLAttributes)]]
  },

  renderText({ node }) {
    return node.attrs.src
  },

  addCommands() {
    return {
      setIframe: options => ({ tr, dispatch }) => {
        const { selection } = tr
        const node = this.type.create(options)

        if (dispatch) {
          tr.replaceRangeWith(selection.from, selection.to, node)
        }

        return true
      },
    }
  },

  addInputRules() {
    return [
      nodeInputRule({
        find: inputRegex,
        type: this.type,
        getAttributes: match => {
          const [, src] = match
          return { src }
        }
      }),
    ]
  },
});
