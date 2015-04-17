# My code has not passed three of the tests, which are snd == snd_fade_out, 
# snd == snd_fade, and snd == snd_left_to_right. However, by listening to them I
# can tell that they sound as they are supposed to. I do not know what is wrong 
# with them. Also, I cannot get my functions to actually return the changed 
# sounds by simply calling them; I have to make a new variable and make that 
# equal to the result of the function; rather than simply calling fade(snd) and 
# being able to play snd_fade I must say snd_fade = fade(snd) 
# and then play snd_fade. 


import sound

snd = sound.load_sound ('love.wav')

def rem_vocals(snd):
    '''Return a copy of snd where the vocals have been removed.'''
    
    snd_rem_vocals = sound.copy(snd)
    for sample in snd_rem_vocals:
        left = sound.get_left(sample)
        right = sound.get_right(sample)
        new_value = (left-right)/2.0
        new_value = int(new_value)
        sound.set_left (sample, new_value)
        sound.set_right (sample, new_value)
    return snd_rem_vocals

snd_rem_vocals = rem_vocals(snd)

sound.play(snd_rem_vocals)


def fade_in (snd, fade_length):
    '''Return a copy of snd where a fade-in is applied to the samples 
    from 0 to (fade_length-1).'''
    
    snd_fade_in = sound.copy(snd)
    for sample in snd_fade_in:
        index = sound.get_index(sample)
        if index< fade_length:
            factor = index/float(fade_length)
            left = sound.get_left(sample)
            right = sound.get_right(sample)
            left = int(left*factor)
            right = int(right*factor)
            sound.set_left (sample, left)
            sound.set_right (sample, right)
    return snd_fade_in

snd_fade_in = fade_in(snd, 200000)

sound.play(snd_fade_in)


def fade_out (snd, fade_length):
    '''Return a copy of snd where a fade-out is applied to the samples
    from ((len(snd)-fade_length)+1) to the end of snd.'''
    snd_fade_out = sound.copy(snd)
    length = len(snd_fade_out)
    for sample in snd_fade_out:
        index = sound.get_index(sample)
        if index > (length-fade_length):
            factor = (length-index)/float(fade_length)
            left = sound.get_left(sample)
            right = sound.get_right(sample)
            left = int(left*factor)
            right = int(right*factor)
            sound.set_left(sample, left)
            sound.set_right(sample, right)
    return snd_fade_out
    
snd_fade_out = fade_out(snd, 200000)

sound.play(snd_fade_out)


def fade (snd, fade_length):
    '''Return a copy of snd where a fade-in is applied to the samples 
    from 0 to (fade_length-1) and a fade-out is applied to the samples
    from (len(snd)-fade_length) to the end of snd.'''
    
    snd_fade = sound.copy(snd)
    length = len(snd_fade)
    for sample in snd_fade:
        index = sound.get_index(sample)
        if index > (length-fade_length):
            factor = (length-index)/float(fade_length)
            left = sound.get_left(sample)
            right = sound.get_right(sample)
            left = int(left*factor)
            right = int(right*factor)
            sound.set_left(sample, left)
            sound.set_right(sample, right)
    for sample in snd_fade:
        index = sound.get_index(sample)
        if index < fade_length:
            factor = index/float(fade_length)
            left = sound.get_left(sample)
            right = sound.get_right(sample)
            left = int(left*factor)
            right = int(right*factor)
            sound.set_left (sample, left)
            sound.set_right (sample, right)
    return snd_fade

snd_fade = fade (snd, 200000)

sound.play(snd_fade)


def left_to_right (snd, pan_length):
    '''Return a copy of snd where the intensity of the left channel deccreases 
    to 0 from normal and the intensity of the right channel increases to normal 
    from 0, spanning 0 to (pan_length-1).'''
    
    snd_left_to_right = sound.copy(snd)
    for sample in snd_left_to_right:
        index = sound.get_index(sample)
        if index < pan_length:
            factor_left = (pan_length-index)/float(pan_length)
            factor_right = index/float(pan_length)
            left = sound.get_left(sample)
            right = sound.get_right(sample)
            left = int(left*factor_left)
            right = int(right*factor_right)
            sound.set_left (sample, left)
            sound.set_right (sample, right)
    return snd_left_to_right

snd_left_to_right = left_to_right (snd, 200000)

sound.play(snd_left_to_right)
            
