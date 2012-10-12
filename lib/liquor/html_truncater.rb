# Thanks to https://gist.github.com/101410 and other sources

module Liquor::HTMLTruncater
  extend self

  def truncate(input, number = 300, truncate_string = "...")
    doc = Nokogiri::HTML(input.to_s, nil, "UTF-8")

    current = doc.children.first
    count = 0

    while true
      # we found a text node
      if current.is_a?(Nokogiri::XML::Text)
        count += current.text.mb_chars.length
        # we reached our limit, let's get outta here!
        break if count > number
        previous = current
      end

      if current.children.length > 0
        # this node has children, can't be a text node,
        # lets descend and look for text nodes
        current = current.children.first
      elsif !current.next.nil?
        #this has no children, but has a sibling, let's check it out
        current = current.next
      else
        # we are the last child, we need to ascend until we are
        # either done or find a sibling to continue on to
        n = current
        while !n.is_a?(Nokogiri::HTML::Document) and n.parent.next.nil?
          n = n.parent
        end

        # we've reached the top and found no more text nodes, break
        if n.is_a?(Nokogiri::HTML::Document)
          break;
        else
          current = n.parent.next
        end
      end
    end

    if count >= number
      unless count == number
        new_content = current.text.mb_chars

        index = number-(count-new_content.length)-1
        if index >= 0
          new_content = new_content[0..index]
          current.send(:native_content=, new_content + truncate_string)
        else
          current = previous
          current.send(:native_content=, current.content + truncate_string)
        end
      end

      # remove everything else
      while !current.is_a?(Nokogiri::HTML::Document)
        while !current.next.nil?
          current.next.remove
        end
        current = current.parent
      end
    end

    # now we grab the html and not the text.
    # we do first because nokogiri adds html and body tags
    # which we don't want
    if doc.root.present?
      doc.root.children.first.inner_html
    else # no root element present (probably empty?), will return the first element
      doc.children.first.inner_html
    end
  end

  def truncate_words(input, num_words, truncate_string = "...")
    doc = Nokogiri::HTML(input)

    current = doc.children.first
    count = 0

    while true
      # we found a text node
      if current.is_a?(Nokogiri::XML::Text)
        count += current.text.split.length
        # we reached our limit, let's get outta here!
        break if count > num_words
        previous = current
      end

      if current.children.length > 0
        # this node has children, can't be a text node,
        # lets descend and look for text nodes
        current = current.children.first
      elsif !current.next.nil?
        #this has no children, but has a sibling, let's check it out
        current = current.next
      else
        # we are the last child, we need to ascend until we are
        # either done or find a sibling to continue on to
        n = current
        while !n.is_a?(Nokogiri::HTML::Document) and n.parent.next.nil?
          n = n.parent
        end

        # we've reached the top and found no more text nodes, break
        if n.is_a?(Nokogiri::HTML::Document)
          break;
        else
          current = n.parent.next
        end
      end
    end

    if count >= num_words
      unless count == num_words
        new_content = current.text.split

        # If we're here, the last text node we counted eclipsed the number of words
        # that we want, so we need to cut down on words.  The easiest way to think about
        # this is that without this node we'd have fewer words than the limit, so all
        # the previous words plus a limited number of words from this node are needed.
        # We simply need to figure out how many words are needed and grab that many.
        # Then we need to -subtract- an index, because the first word would be index zero.

        # For example, given:
        # <p>Testing this HTML truncater.</p><p>To see if its working.</p>
        # Let's say I want 6 words.  The correct returned string would be:
        # <p>Testing this HTML truncater.</p><p>To see...</p>
        # All the words in both paragraphs = 9
        # The last paragraph is the one that breaks the limit.  How many words would we
        # have without it? 4.  But we want up to 6, so we might as well get that many.
        # 6 - 4 = 2, so we get 2 words from this node, but words #1-2 are indices #0-1, so
        # we subtract 1.  If this gives us -1, we want nothing from this node. So go back to
        # the previous node instead.
        index = num_words-(count-new_content.length)-1
        if index >= 0
          new_content = new_content[0..index]
          current.content = new_content.join(' ') + truncate_string
        else
          current = previous
          current.content = current.content + truncate_string
        end
      end

      # remove everything else
      while !current.is_a?(Nokogiri::HTML::Document)
        while !current.next.nil?
          current.next.remove
        end
        current = current.parent
      end
    end

    # now we grab the html and not the text.
    # we do first because nokogiri adds html and body tags
    # which we don't want
    doc.root.children.first.inner_html
  end
end
